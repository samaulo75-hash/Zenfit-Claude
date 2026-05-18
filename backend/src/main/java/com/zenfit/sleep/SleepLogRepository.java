package com.zenfit.sleep;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SleepLogRepository extends JpaRepository<SleepLog, UUID> {

    List<SleepLog> findByUserIdOrderBySleepDateDesc(UUID userId, Pageable pageable);

    Optional<SleepLog> findByUserIdAndSleepDate(UUID userId, LocalDate sleepDate);

    Optional<SleepLog> findByIdAndUserId(UUID id, UUID userId);
}
