package com.zenfit.diet.dto;

import com.zenfit.diet.Food;

import java.math.BigDecimal;
import java.util.UUID;

public record FoodResponse(
        UUID id,
        String name,
        String category,
        BigDecimal kcalPer100g,
        BigDecimal proteinPer100g,
        BigDecimal carbsPer100g,
        BigDecimal fatPer100g
) {
    public static FoodResponse from(Food f) {
        return new FoodResponse(
                f.getId(),
                f.getName(),
                f.getCategory(),
                f.getKcalPer100g(),
                f.getProteinPer100g(),
                f.getCarbsPer100g(),
                f.getFatPer100g()
        );
    }
}
