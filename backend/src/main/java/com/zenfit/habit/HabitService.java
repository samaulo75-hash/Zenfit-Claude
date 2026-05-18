package com.zenfit.habit;

import com.zenfit.common.enums.HabitFrequency;
import com.zenfit.common.error.NotFoundException;
import com.zenfit.habit.dto.CreateHabitRequest;
import com.zenfit.habit.dto.HabitResponse;
import com.zenfit.habit.dto.UpdateHabitRequest;
import com.zenfit.user.User;
import com.zenfit.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class HabitService {

    private final HabitRepository habitRepository;
    private final HabitLogRepository habitLogRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<HabitResponse> list(UUID userId) {
        return habitRepository.findByUserIdOrderByCreatedAtAsc(userId).stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public HabitResponse create(UUID userId, CreateHabitRequest req) {
        User user = userRepository.getReferenceById(userId);
        Habit habit = Habit.builder()
                .user(user)
                .name(req.name().trim())
                .description(req.description())
                .frequency(req.frequency() != null ? req.frequency() : HabitFrequency.DAILY)
                .targetPerPeriod(req.targetPerPeriod() != null ? req.targetPerPeriod() : 1)
                .color(req.color())
                .icon(req.icon())
                .active(true)
                .build();
        return toResponse(habitRepository.save(habit));
    }

    @Transactional
    public HabitResponse update(UUID userId, UUID habitId, UpdateHabitRequest req) {
        Habit habit = habitRepository.findByIdAndUserId(habitId, userId)
                .orElseThrow(() -> new NotFoundException("Habit not found"));
        habit.setName(req.name().trim());
        habit.setDescription(req.description());
        if (req.frequency() != null) habit.setFrequency(req.frequency());
        if (req.targetPerPeriod() != null) habit.setTargetPerPeriod(req.targetPerPeriod());
        habit.setColor(req.color());
        habit.setIcon(req.icon());
        if (req.active() != null) habit.setActive(req.active());
        return toResponse(habitRepository.save(habit));
    }

    @Transactional
    public void delete(UUID userId, UUID habitId) {
        Habit habit = habitRepository.findByIdAndUserId(habitId, userId)
                .orElseThrow(() -> new NotFoundException("Habit not found"));
        habitRepository.delete(habit);
    }

    /** Marca/desmarca el hábito como completado en una fecha (toggle). */
    @Transactional
    public HabitResponse toggle(UUID userId, UUID habitId, LocalDate date) {
        Habit habit = habitRepository.findByIdAndUserId(habitId, userId)
                .orElseThrow(() -> new NotFoundException("Habit not found"));
        LocalDate day = date != null ? date : LocalDate.now();

        habitLogRepository.findByHabitIdAndLogDate(habitId, day)
                .ifPresentOrElse(
                        habitLogRepository::delete,
                        () -> habitLogRepository.save(HabitLog.builder()
                                .habit(habit)
                                .logDate(day)
                                .completed(true)
                                .build())
                );
        return toResponse(habit);
    }

    private HabitResponse toResponse(Habit habit) {
        List<HabitLog> logs = habitLogRepository.findByHabitIdOrderByLogDateDesc(habit.getId());
        Set<LocalDate> doneDays = new HashSet<>();
        for (HabitLog l : logs) {
            if (l.isCompleted()) doneDays.add(l.getLogDate());
        }

        boolean completedToday = doneDays.contains(LocalDate.now());

        // Racha: días consecutivos hacia atrás desde hoy (o desde ayer si hoy no está hecho)
        int streak = 0;
        LocalDate cursor = LocalDate.now();
        if (!doneDays.contains(cursor)) {
            cursor = cursor.minusDays(1);
        }
        while (doneDays.contains(cursor)) {
            streak++;
            cursor = cursor.minusDays(1);
        }

        long total = doneDays.size();
        return HabitResponse.from(habit, completedToday, streak, total);
    }
}
