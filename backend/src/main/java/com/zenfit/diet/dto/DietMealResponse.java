package com.zenfit.diet.dto;

import com.zenfit.common.enums.MealType;
import com.zenfit.diet.DietMeal;

public record DietMealResponse(
        MealType mealType,
        String name,
        String description,
        Integer calories,
        int position
) {
    public static DietMealResponse from(DietMeal m) {
        return new DietMealResponse(
                m.getMealType(),
                m.getName(),
                m.getDescription(),
                m.getCalories(),
                m.getPosition()
        );
    }
}
