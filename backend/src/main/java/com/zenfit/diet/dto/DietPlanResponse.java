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
        boolean premium,
        List<DietMealResponse> meals
) {
    public static DietPlanResponse from(DietPlan p, List<DietMealResponse> meals) {
        return new DietPlanResponse(
                p.getId(),
                p.getName(),
                p.getDescription(),
                p.getGoal(),
                p.getCaloriesPerDay(),
                p.getImageUrl(),
                p.isPremium(),
                meals
        );
    }
}
