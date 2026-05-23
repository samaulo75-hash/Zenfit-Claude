package com.zenfit.auth.dto;

import java.time.OffsetDateTime;

/**
 * Respuesta del flujo "olvidé mi contraseña".
 * En esta versión (sin SMTP configurado) devolvemos el token directamente al
 * cliente para que la UI muestre el enlace de reset. En producción real este
 * token NO se devolvería en la respuesta — solo se enviaría por email.
 */
public record ForgotPasswordResponse(
        String token,
        OffsetDateTime expiresAt
) {}
