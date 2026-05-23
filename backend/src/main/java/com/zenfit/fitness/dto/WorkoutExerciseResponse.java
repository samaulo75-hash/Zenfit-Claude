package com.zenfit.fitness.dto;

import com.zenfit.fitness.Exercise;
import com.zenfit.fitness.WorkoutExercise;

import java.util.UUID;

public record WorkoutExerciseResponse(
        UUID exerciseId,
        String exerciseName,
        String exerciseDescription,
        String exerciseInstructions,
        String exerciseTips,
        String exerciseVideoUrl,
        int position,
        Integer sets,
        Integer reps,
        Integer durationSeconds,
        Integer restSeconds,
        String notes
) {
    public static WorkoutExerciseResponse from(WorkoutExercise we) {
        Exercise ex = we.getExercise();
        return new WorkoutExerciseResponse(
                ex.getId(),
                ex.getName(),
                ex.getDescription(),
                ex.getInstructions(),
                ex.getTips(),
                ex.getVideoUrl(),
                we.getPosition(),
                we.getSets(),
                we.getReps(),
                we.getDurationSeconds(),
                we.getRestSeconds(),
                we.getNotes()
        );
    }
}
