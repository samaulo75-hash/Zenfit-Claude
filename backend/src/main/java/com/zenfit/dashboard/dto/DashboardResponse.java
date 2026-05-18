package com.zenfit.dashboard.dto;

import com.zenfit.fitness.dto.WorkoutSessionResponse;
import com.zenfit.habit.dto.HabitResponse;
import com.zenfit.sleep.dto.SleepLogResponse;

import java.util.List;

public record DashboardResponse(
        String userFullName,
        long totalWorkouts,
        long workoutsThisWeek,
        int habitsCompletedToday,
        int habitsTotal,
        int bestHabitStreak,
        SleepLogResponse lastSleep,
        List<WorkoutSessionResponse> recentSessions,
        List<HabitResponse> habits
) {}
