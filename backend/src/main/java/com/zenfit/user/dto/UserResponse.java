package com.zenfit.user.dto;

import com.zenfit.common.enums.PlanType;
import com.zenfit.common.enums.UserRole;
import com.zenfit.user.User;

import java.time.OffsetDateTime;
import java.util.UUID;

public record UserResponse(
        UUID id,
        String email,
        String fullName,
        String avatarUrl,
        UserRole role,
        PlanType plan,
        boolean emailVerified,
        OffsetDateTime createdAt
) {
    public static UserResponse from(User user) {
        return new UserResponse(
                user.getId(),
                user.getEmail(),
                user.getFullName(),
                user.getAvatarUrl(),
                user.getRole(),
                user.getPlan(),
                user.isEmailVerified(),
                user.getCreatedAt()
        );
    }
}
