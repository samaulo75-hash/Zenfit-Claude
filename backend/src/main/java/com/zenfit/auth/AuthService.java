package com.zenfit.auth;

import com.zenfit.auth.dto.AuthResponse;
import com.zenfit.auth.dto.ChangePasswordRequest;
import com.zenfit.auth.dto.ForgotPasswordRequest;
import com.zenfit.auth.dto.ForgotPasswordResponse;
import com.zenfit.auth.dto.LoginRequest;
import com.zenfit.auth.dto.RefreshRequest;
import com.zenfit.auth.dto.RegisterRequest;
import com.zenfit.auth.dto.ResetPasswordRequest;
import com.zenfit.auth.jwt.JwtService;
import com.zenfit.common.error.ConflictException;
import com.zenfit.common.error.NotFoundException;
import com.zenfit.common.enums.PlanType;
import com.zenfit.common.enums.UserRole;
import com.zenfit.user.User;
import com.zenfit.user.UserRepository;
import com.zenfit.user.dto.UserResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private static final long PASSWORD_RESET_TOKEN_TTL_MINUTES = 30;
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new ConflictException("Email is already registered");
        }
        User user = User.builder()
                .email(request.email().toLowerCase().trim())
                .passwordHash(passwordEncoder.encode(request.password()))
                .fullName(request.fullName().trim())
                .role(UserRole.USER)
                .plan(PlanType.FREE)
                .active(true)
                .emailVerified(false)
                .build();
        user = userRepository.save(user);
        return issueTokens(user);
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        Authentication auth;
        try {
            auth = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.email().toLowerCase().trim(),
                            request.password()));
        } catch (BadCredentialsException ex) {
            throw new BadCredentialsException("Invalid email or password");
        }

        String email = auth.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("User not found"));
        user.setLastLoginAt(OffsetDateTime.now());
        return issueTokens(user);
    }

    @Transactional
    public AuthResponse refresh(RefreshRequest request) {
        RefreshToken stored = refreshTokenRepository.findByToken(request.refreshToken())
                .orElseThrow(() -> new BadCredentialsException("Invalid refresh token"));

        if (stored.isRevoked() || stored.getExpiresAt().isBefore(OffsetDateTime.now())) {
            throw new BadCredentialsException("Refresh token expired or revoked");
        }

        stored.setRevoked(true);
        refreshTokenRepository.save(stored);

        return issueTokens(stored.getUser());
    }

    @Transactional
    public void logout(String refreshToken) {
        refreshTokenRepository.findByToken(refreshToken).ifPresent(rt -> {
            rt.setRevoked(true);
            refreshTokenRepository.save(rt);
        });
    }

    /**
     * Cambia la contraseña del usuario autenticado verificando la actual.
     * Invalida todos los refresh tokens activos para forzar re-login en
     * otros dispositivos.
     */
    @Transactional
    public void changePassword(UUID userId, ChangePasswordRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        if (!passwordEncoder.matches(request.currentPassword(), user.getPasswordHash())) {
            throw new BadCredentialsException("Current password is incorrect");
        }
        if (passwordEncoder.matches(request.newPassword(), user.getPasswordHash())) {
            throw new ConflictException("The new password must be different from the current one");
        }

        user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
        refreshTokenRepository.revokeAllForUser(user);
        log.info("User {} changed their password", user.getEmail());
    }

    /**
     * Genera un token de reset para el email indicado.
     * Por seguridad NO revela si el email existe o no — siempre responde 200
     * con el token (cuando existe) o con un token "fantasma" (cuando no).
     * En esta versión devolvemos el token al cliente porque no hay SMTP
     * configurado; en producción real solo se enviaría por email.
     */
    @Transactional
    public ForgotPasswordResponse forgotPassword(ForgotPasswordRequest request) {
        String email = request.email().toLowerCase().trim();
        OffsetDateTime expiresAt = OffsetDateTime.now().plus(PASSWORD_RESET_TOKEN_TTL_MINUTES, ChronoUnit.MINUTES);

        return userRepository.findByEmail(email)
                .map(user -> {
                    passwordResetTokenRepository.invalidateAllForUser(user);
                    String token = generateResetToken();
                    PasswordResetToken prt = PasswordResetToken.builder()
                            .user(user)
                            .token(token)
                            .expiresAt(expiresAt)
                            .used(false)
                            .build();
                    passwordResetTokenRepository.save(prt);
                    log.info("Generated password reset token for user {}", user.getEmail());
                    return new ForgotPasswordResponse(token, expiresAt);
                })
                // Si el email no existe, devolvemos un token aleatorio que no sirve
                // para nada (no se guarda en BBDD). Así no filtramos qué emails
                // están registrados, pero la UI puede mostrar el mismo flujo.
                .orElseGet(() -> new ForgotPasswordResponse(generateResetToken(), expiresAt));
    }

    /**
     * Aplica la nueva contraseña usando el token de reset. Invalida el token
     * tras usarlo y revoca los refresh tokens activos del usuario.
     */
    @Transactional
    public void resetPassword(ResetPasswordRequest request) {
        PasswordResetToken prt = passwordResetTokenRepository.findByToken(request.token())
                .orElseThrow(() -> new BadCredentialsException("Invalid or expired reset token"));

        if (prt.isUsed() || prt.getExpiresAt().isBefore(OffsetDateTime.now())) {
            throw new BadCredentialsException("Invalid or expired reset token");
        }

        User user = prt.getUser();
        user.setPasswordHash(passwordEncoder.encode(request.newPassword()));
        prt.setUsed(true);
        passwordResetTokenRepository.save(prt);
        refreshTokenRepository.revokeAllForUser(user);
        log.info("User {} reset their password via token", user.getEmail());
    }

    private String generateResetToken() {
        byte[] bytes = new byte[48];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private AuthResponse issueTokens(User user) {
        String accessToken = jwtService.generateAccessToken(user);
        String refreshTokenValue = jwtService.generateRefreshTokenValue();

        RefreshToken refreshToken = RefreshToken.builder()
                .user(user)
                .token(refreshTokenValue)
                .expiresAt(OffsetDateTime.now().plus(jwtService.refreshTokenExpirationMs(), ChronoUnit.MILLIS))
                .revoked(false)
                .build();
        refreshTokenRepository.save(refreshToken);

        return AuthResponse.of(
                accessToken,
                refreshTokenValue,
                jwtService.accessTokenExpirationSeconds(),
                UserResponse.from(user)
        );
    }
}
