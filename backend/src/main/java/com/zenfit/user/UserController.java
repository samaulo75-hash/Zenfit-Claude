package com.zenfit.user;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.user.dto.UpdateUserRequest;
import com.zenfit.user.dto.UpdateWellnessProfileRequest;
import com.zenfit.user.dto.UserResponse;
import com.zenfit.user.dto.WellnessProfileResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/users/me")
@RequiredArgsConstructor
public class UserController {

    private final WellnessProfileService profileService;
    private final UserAccountService accountService;

    @GetMapping
    public ResponseEntity<UserResponse> me(@AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(UserResponse.from(principal.getUser()));
    }

    /** Actualiza datos básicos del usuario (por ahora: solo nombre completo). */
    @PatchMapping
    public ResponseEntity<UserResponse> updateMe(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody UpdateUserRequest request) {
        return ResponseEntity.ok(accountService.updateBasicInfo(principal.getId(), request));
    }

    /** Devuelve todos los datos del usuario en JSON como descarga. */
    @GetMapping("/export")
    public ResponseEntity<Map<String, Object>> exportMyData(@AuthenticationPrincipal AuthenticatedUser principal) {
        Map<String, Object> data = accountService.exportData(principal.getId());
        String filename = "zenfit-export-" + LocalDate.now() + ".json";
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_JSON)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .body(data);
    }

    /** Elimina la cuenta del usuario. Borra en cascada todos sus datos. */
    @DeleteMapping
    public ResponseEntity<Void> deleteMe(@AuthenticationPrincipal AuthenticatedUser principal) {
        accountService.deleteAccount(principal.getId());
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/profile")
    public ResponseEntity<WellnessProfileResponse> getProfile(@AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(profileService.get(principal.getId()));
    }

    @PutMapping("/profile")
    public ResponseEntity<WellnessProfileResponse> updateProfile(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody UpdateWellnessProfileRequest request) {
        return ResponseEntity.ok(profileService.update(principal.getId(), request));
    }
}
