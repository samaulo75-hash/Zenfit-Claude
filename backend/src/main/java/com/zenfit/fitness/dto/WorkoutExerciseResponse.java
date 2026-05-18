package com.zenfit.fitness.dto;

import com.zenfit.fitness.WorkoutExercise;

import java.util.UUID;

public record WorkoutExerciseResponse(
        UUID exerciseId,
        String exerciseName,
        int position,
        Integer sets,
        Integer reps,
        Integer durationSeconds,
        Integer restSeconds,
        String notes
) {
    public static WorkoutExerciseResponse from(WorkoutExercise we) {
        return new WorkoutExerciseResponse(
                we.getExercise().getId(),
                we.getExercise().getName(),
                we.getPosition(),
                we.getSets(),
                we.getReps(),
                we.getDurationSeconds(),
                we.getRestSeconds(),
                we.getNotes()
        );
    }
}
