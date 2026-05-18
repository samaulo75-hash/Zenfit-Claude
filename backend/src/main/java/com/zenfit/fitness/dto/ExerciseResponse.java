package com.zenfit.fitness.dto;

import com.zenfit.common.enums.DifficultyLevel;
import com.zenfit.fitness.Exercise;

import java.util.List;
import java.util.UUID;

public record ExerciseResponse(
        UUID id,
        String name,
        String description,
        String videoUrl,
        String imageUrl,
        DifficultyLevel difficulty,
        Integer estimatedSeconds,
        List<String> muscleGroups,
        List<String> equipment,
        boolean premium
) {
    public static ExerciseResponse from(Exercise e) {
        return new ExerciseResponse(
                e.getId(),
                e.getName(),
                e.getDescription(),
                e.getVideoUrl(),
                e.getImageUrl(),
                e.getDifficulty(),
                e.getEstimatedSeconds(),
                e.getMuscleGroups() == null ? List.of() : List.of(e.getMuscleGroups()),
                e.getEquipment() == null ? List.of() : List.of(e.getEquipment()),
                e.isPremium()
        );
    }
}
