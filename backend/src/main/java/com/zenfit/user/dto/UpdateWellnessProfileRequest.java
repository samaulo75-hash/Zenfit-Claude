package com.zenfit.user.dto;

import com.zenfit.common.enums.ActivityLevel;
import com.zenfit.common.enums.FitnessGoal;
import com.zenfit.common.enums.Gender;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDate;

public record UpdateWellnessProfileRequest(
        @PastOrPresent
        LocalDate dateOfBirth,

        Gender gender,

        @DecimalMin("0.0") @DecimalMax("300.0")
        BigDecimal heightCm,

        @DecimalMin("0.0") @DecimalMax("500.0")
        BigDecimal weightKg,

        FitnessGoal fitnessGoal,

        ActivityLevel activityLevel,

        @Size(max = 2000)
        String medicalNotes
) {}
