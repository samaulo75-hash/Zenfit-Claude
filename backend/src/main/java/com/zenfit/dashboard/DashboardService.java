package com.zenfit.dashboard;

import com.zenfit.dashboard.dto.DashboardResponse;
import com.zenfit.fitness.FitnessService;
import com.zenfit.fitness.WorkoutSessionRepository;
import com.zenfit.fitness.dto.WorkoutSessionResponse;
import com.zenfit.habit.HabitService;
import com.zenfit.habit.dto.HabitResponse;
import com.zenfit.sleep.SleepService;
import com.zenfit.sleep.dto.SleepLogResponse;
import com.zenfit.user.User;
import com.zenfit.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class DashboardService {

    private final UserRepository userRepository;
    private final WorkoutSessionRepository workoutSessionRepository;
    private final HabitService habitService;
    private final SleepService sleepService;
    private final FitnessService fitnessService;

    @Transactional(readOnly = true)
    public DashboardResponse build(UUID userId) {
        User user = userRepository.getReferenceById(userId);

        long totalWorkouts = workoutSessionRepository.countByUserId(userId);
        long workoutsThisWeek = workoutSessionRepository
                .countByUserIdAndStartedAtAfter(userId, OffsetDateTime.now().minusDays(7));

        List<HabitResponse> habits = habitService.list(userId);
        int habitsCompletedToday = (int) habits.stream().filter(HabitResponse::completedToday).count();
        int bestStreak = habits.stream().mapToInt(HabitResponse::currentStreak).max().orElse(0);

        List<SleepLogResponse> sleep = sleepService.list(userId, 1);
        SleepLogResponse lastSleep = sleep.isEmpty() ? null : sleep.get(0);

        List<WorkoutSessionResponse> recentSessions = fitnessService.listSessions(userId, 5);

        return new DashboardResponse(
                user.getFullName(),
                totalWorkouts,
                workoutsThisWeek,
                habitsCompletedToday,
                habits.size(),
                bestStreak,
                lastSleep,
                recentSessions,
                habits
        );
    }
}
