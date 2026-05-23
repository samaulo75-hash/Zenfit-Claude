package com.zenfit.diet.dto;

import com.zenfit.diet.CustomDietItem;

import java.math.BigDecimal;
import java.util.UUID;

public record CustomDietItemResponse(
        UUID id,
        UUID foodId,
        String foodName,
        BigDecimal grams,
        BigDecimal kcal,
        int position
) {
    public static CustomDietItemResponse from(CustomDietItem i) {
        String name = i.getFood() != null ? i.getFood().getName() : i.getFoodNameFreetext();
        UUID foodId = i.getFood() != null ? i.getFood().getId() : null;
        return new CustomDietItemResponse(
                i.getId(),
                foodId,
                name,
                i.getGrams(),
                i.getKcal(),
                i.getPosition()
        );
    }
}
