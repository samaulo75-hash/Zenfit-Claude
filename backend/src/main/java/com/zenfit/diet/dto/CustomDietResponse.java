package com.zenfit.diet.dto;

import com.zenfit.diet.CustomDiet;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

public record CustomDietResponse(
        UUID id,
        String name,
        String description,
        BigDecimal totalKcal,
        List<CustomDietItemResponse> items,
        OffsetDateTime createdAt,
        OffsetDateTime updatedAt
) {
    public static CustomDietResponse from(CustomDiet d) {
        return new CustomDietResponse(
                d.getId(),
                d.getName(),
                d.getDescription(),
                d.getTotalKcal(),
                d.getItems().stream().map(CustomDietItemResponse::from).toList(),
                d.getCreatedAt(),
                d.getUpdatedAt()
        );
    }
}
