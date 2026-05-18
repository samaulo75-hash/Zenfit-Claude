package com.zenfit.habit.dto;

import com.zenfit.common.enums.HabitFrequency;
import com.zenfit.habit.Habit;

import java.util.UUID;

public record HabitResponse(
        UUID id,
        String name,
        String description,
        HabitFrequency frequency,
        Integer targetPerPeriod,
        String color,
        String icon,
        boolean active,
        boolean completedToday,
        int currentStreak,
        long totalCompletions
) {
    public static HabitResponse from(Habit h, boolean completedToday, int currentStreak, long totalCompletions) {
        return new HabitResponse(
                h.getId(),
                h.getName(),
                h.getDescription(),
                h.getFrequency(),
                h.getTargetPerPeriod(),
                h.getColor(),
                h.getIcon(),
                h.isActive(),
                completedToday,
                currentStreak,
                totalCompletions
        );
    }
}
