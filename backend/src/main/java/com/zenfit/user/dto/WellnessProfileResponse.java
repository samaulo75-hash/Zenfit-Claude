package com.zenfit.user.dto;

import com.zenfit.common.enums.ActivityLevel;
import com.zenfit.common.enums.FitnessGoal;
import com.zenfit.common.enums.Gender;
import com.zenfit.user.WellnessProfile;

import java.math.BigDecimal;
import java.time.LocalDate;

public record WellnessProfileResponse(
        LocalDate dateOfBirth,
        Gender gender,
        BigDecimal heightCm,
        BigDecimal weightKg,
        FitnessGoal fitnessGoal,
        ActivityLevel activityLevel,
        String medicalNotes
) {
    public static WellnessProfileResponse from(WellnessProfile p) {
        return new WellnessProfileResponse(
                p.getDateOfBirth(),
                p.getGender(),
                p.getHeightCm(),
                p.getWeightKg(),
                p.getFitnessGoal(),
                p.getActivityLevel(),
                p.getMedicalNotes()
        );
    }
}
