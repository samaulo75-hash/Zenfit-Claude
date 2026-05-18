package com.zenfit.habit.dto;

import com.zenfit.common.enums.HabitFrequency;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateHabitRequest(
        @NotBlank @Size(max = 150) String name,
        @Size(max = 1000) String description,
        HabitFrequency frequency,
        @Min(1) Integer targetPerPeriod,
        @Size(max = 20) String color,
        @Size(max = 50) String icon,
        Boolean active
) {}
