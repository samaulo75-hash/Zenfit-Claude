package com.zenfit.habit;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface HabitLogRepository extends JpaRepository<HabitLog, UUID> {

    Optional<HabitLog> findByHabitIdAndLogDate(UUID habitId, LocalDate logDate);

    List<HabitLog> findByHabitIdOrderByLogDateDesc(UUID habitId);

    long countByHabitIdAndCompletedTrue(UUID habitId);
}
