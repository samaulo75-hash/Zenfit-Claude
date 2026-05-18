package com.zenfit.sleep.dto;

import com.zenfit.sleep.SleepLog;

import java.time.LocalDate;
import java.util.UUID;

public record SleepLogResponse(
        UUID id,
        LocalDate sleepDate,
        Integer durationMinutes,
        Short quality,
        String notes
) {
    public static SleepLogResponse from(SleepLog s) {
        return new SleepLogResponse(
                s.getId(),
                s.getSleepDate(),
                s.getDurationMinutes(),
                s.getQuality(),
                s.getNotes()
        );
    }
}
