package com.zenfit.fitness.dto;

import com.zenfit.fitness.WorkoutSession;

import java.time.OffsetDateTime;
import java.util.UUID;

public record WorkoutSessionResponse(
        UUID id,
        UUID workoutId,
        String workoutName,
        OffsetDateTime startedAt,
        OffsetDateTime completedAt,
        Integer durationSeconds,
        Integer caloriesBurned,
        Short perceivedEffort,
        String notes
) {
    public static WorkoutSessionResponse from(WorkoutSession s) {
        return new WorkoutSessionResponse(
                s.getId(),
                s.getWorkout() != null ? s.getWorkout().getId() : null,
                s.getWorkout() != null ? s.getWorkout().getName() : "Entrenamiento libre",
                s.getStartedAt(),
                s.getCompletedAt(),
                s.getDurationSeconds(),
                s.getCaloriesBurned(),
                s.getPerceivedEffort(),
                s.getNotes()
        );
    }
}
