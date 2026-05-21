package com.zenfit.diet;

import com.zenfit.common.enums.DietGoal;
import com.zenfit.common.enums.FitnessGoal;
import com.zenfit.common.error.NotFoundException;
import com.zenfit.diet.dto.DietMealResponse;
import com.zenfit.diet.dto.DietPlanResponse;
import com.zenfit.user.WellnessProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class DietService {

    private final DietPlanRepository dietPlanRepository;
    private final DietMealRepository dietMealRepository;
    private final WellnessProfileRepository profileRepository;

    @Transactional(readOnly = true)
    public List<DietPlanResponse> list(DietGoal goal) {
        List<DietPlan> plans = (goal == null)
                ? dietPlanRepository.findAllByOrderByCreatedAtAsc()
                : dietPlanRepository.findByGoalOrderByCreatedAtAsc(goal);
        return plans.stream().map(p -> DietPlanResponse.from(p, mealsOf(p.getId()))).toList();
    }

    @Transactional(readOnly = true)
    public DietPlanResponse get(UUID id) {
        DietPlan p = dietPlanRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Diet plan not found"));
        return DietPlanResponse.from(p, mealsOf(p.getId()));
    }

    /** Dietas recomendadas según el objetivo del perfil de bienestar del usuario. */
    @Transactional(readOnly = true)
    public List<DietPlanResponse> recommendedFor(UUID userId) {
        DietGoal goal = profileRepository.findByUserId(userId)
                .map(p -> mapGoal(p.getFitnessGoal()))
                .orElse(null);
        if (goal == null) {
            return list(null);
        }
        List<DietPlanResponse> recommended = list(goal);
        return recommended.isEmpty() ? list(null) : recommended;
    }

    private List<DietMealResponse> mealsOf(UUID planId) {
        return dietMealRepository.findByDietPlanIdOrderByPositionAsc(planId).stream()
                .map(DietMealResponse::from)
                .toList();
    }

    private DietGoal mapGoal(FitnessGoal fitnessGoal) {
        if (fitnessGoal == null) return null;
        return switch (fitnessGoal) {
            case LOSE_WEIGHT -> DietGoal.LOSE_WEIGHT;
            case GAIN_MUSCLE -> DietGoal.GAIN_MUSCLE;
            case MAINTAIN -> DietGoal.MAINTAIN;
            case IMPROVE_ENDURANCE, REDUCE_STRESS, BETTER_SLEEP -> DietGoal.BALANCED;
        };
    }
}
