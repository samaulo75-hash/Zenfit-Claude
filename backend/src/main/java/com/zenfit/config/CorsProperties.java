package com.zenfit.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.Arrays;
import java.util.List;

/**
 * Orígenes permitidos para CORS.
 * Se define como un único string separado por comas para que sea trivial
 * configurarlo con una sola variable de entorno en producción
 * (p. ej. ZENFIT_CORS_ALLOWED_ORIGINS=https://mi-frontend.onrender.com).
 */
@ConfigurationProperties(prefix = "zenfit.cors")
public record CorsProperties(String allowedOrigins) {

    public List<String> origins() {
        if (allowedOrigins == null || allowedOrigins.isBlank()) {
            return List.of();
        }
        return Arrays.stream(allowedOrigins.split(","))
                .map(String::trim)
                .filter(s -> !s.isBlank())
                .toList();
    }
}
