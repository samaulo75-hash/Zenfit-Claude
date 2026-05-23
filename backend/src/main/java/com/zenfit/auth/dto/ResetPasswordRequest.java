package com.zenfit.auth.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ResetPasswordRequest(
        @NotBlank
        String token,

        @NotBlank @Size(min = 8, max = 100, message = "Password must be 8-100 characters")
        String newPassword
) {}
