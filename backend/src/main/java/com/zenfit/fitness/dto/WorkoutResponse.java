package com.zenfit.fitness.dto;

import com.zenfit.common.enums.DifficultyLevel;
import com.zenfit.common.enums.WorkoutType;
import com.zenfit.fitness.Workout;

import java.util.List;
import java.util.UUID;

public record WorkoutResponse(
        UUID id,
        String name,
        String description,
        WorkoutType type,
        DifficultyLevel difficulty,
        Integer estimatedDurationMinutes,
        String imageUrl,
        boolean premium,
        List<WorkoutExerciseResponse> exercises
) {
    public static WorkoutResponse from(Workout w, List<WorkoutExerciseResponse> exercises) {
        return new WorkoutResponse(
                w.getId(),
                w.getName(),
                w.getDescription(),
                w.getType(),
                w.getDifficulty(),
                w.getEstimatedDurationMinutes(),
                w.getImageUrl(),
                w.isPremium(),
                exercises
        );
    }
}
