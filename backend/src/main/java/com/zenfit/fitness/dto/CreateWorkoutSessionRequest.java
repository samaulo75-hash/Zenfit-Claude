package com.zenfit.fitness.dto;

import jakarta.validation.constraints.Min;

import java.util.UUID;

public record CreateWorkoutSessionRequest(
        UUID workoutId,

        @Min(0) Integer durationSeconds,

        @Min(0) Integer caloriesBurned,

        @Min(1) Short perceivedEffort,

        String notes
) {}
