package com.zenfit.auth.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ChangePasswordRequest(
        @NotBlank
        String currentPassword,

        @NotBlank @Size(min = 8, max = 100, message = "Password must be 8-100 characters")
        String newPassword
) {}
