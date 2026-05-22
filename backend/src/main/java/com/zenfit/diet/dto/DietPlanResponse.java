package com.zenfit.diet.dto;

import com.zenfit.common.enums.DietGoal;
import com.zenfit.diet.DietPlan;

import java.util.List;
import java.util.UUID;

public record DietPlanResponse(
        UUID id,
        String name,
        String description,
        DietGoal goal,
        Integer caloriesPerDay,
        String imageUrl,
        String recipeUrl,
        boolean premium,
        boolean saved,
        List<DietMealResponse> meals
) {
    public static DietPlanResponse from(DietPlan p, List<DietMealResponse> meals, boolean saved) {
        return new DietPlanResponse(
                p.getId(),
                p.getName(),
                p.getDescription(),
                p.getGoal(),
                p.getCaloriesPerDay(),
                p.getImageUrl(),
                p.getRecipeUrl(),
                p.isPremium(),
                saved,
                meals
        );
    }
}
