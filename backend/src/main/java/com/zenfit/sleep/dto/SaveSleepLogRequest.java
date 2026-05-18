package com.zenfit.sleep.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;

public record SaveSleepLogRequest(
        @NotNull @PastOrPresent LocalDate sleepDate,

        @NotNull @Min(0) @Max(1440)
        Integer durationMinutes,

        @Min(1) @Max(5)
        Short quality,

        @Size(max = 1000) String notes
) {}
