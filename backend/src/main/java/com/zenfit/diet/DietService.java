package com.zenfit.diet;

import com.zenfit.common.enums.DietGoal;
import com.zenfit.common.enums.FitnessGoal;
import com.zenfit.common.error.NotFoundException;
import com.zenfit.diet.dto.DietMealResponse;
import com.zenfit.diet.dto.DietPlanResponse;
import com.zenfit.user.UserRepository;
import com.zenfit.user.WellnessProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class DietService {

    private final DietPlanRepository dietPlanRepository;
    private final DietMealRepository dietMealRepository;
    private final SavedDietRepository savedDietRepository;
    private final WellnessProfileRepository profileRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<DietPlanResponse> list(UUID userId, DietGoal goal) {
        List<DietPlan> plans = (goal == null)
                ? dietPlanRepository.findAllByOrderByCreatedAtAsc()
                : dietPlanRepository.findByGoalOrderByCreatedAtAsc(goal);
        Set<UUID> saved = savedIdsOf(userId);
        return plans.stream().map(p -> toResponse(p, saved)).toList();
    }

    @Transactional(readOnly = true)
    public DietPlanResponse get(UUID userId, UUID id) {
        DietPlan p = dietPlanRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Diet plan not found"));
        return toResponse(p, savedIdsOf(userId));
    }

    /** Dietas recomendadas según el objetivo del perfil de bienestar. */
    @Transactional(readOnly = true)
    public List<DietPlanResponse> recommendedFor(UUID userId) {
        DietGoal goal = profileRepository.findByUserId(userId)
                .map(p -> mapGoal(p.getFitnessGoal()))
                .orElse(null);
        if (goal == null) {
            return list(userId, null);
        }
        List<DietPlanResponse> recommended = list(userId, goal);
        return recommended.isEmpty() ? list(userId, null) : recommended;
    }

    /** Dietas que el usuario ha guardado. */
    @Transactional(readOnly = true)
    public List<DietPlanResponse> listSaved(UUID userId) {
        return savedDietRepository.findByUserId(userId).stream()
                .map(sd -> toResponse(sd.getDietPlan(), Set.of(sd.getDietPlan().getId())))
                .toList();
    }

    @Transactional
    public void save(UUID userId, UUID dietId) {
        if (!dietPlanRepository.existsById(dietId)) {
            throw new NotFoundException("Diet plan not found");
        }
        if (savedDietRepository.existsByUserIdAndDietPlanId(userId, dietId)) {
            return;
        }
        SavedDiet sd = SavedDiet.builder()
                .id(new SavedDietId(userId, dietId))
                .user(userRepository.getReferenceById(userId))
                .dietPlan(dietPlanRepository.getReferenceById(dietId))
                .build();
        savedDietRepository.save(sd);
    }

    @Transactional
    public void unsave(UUID userId, UUID dietId) {
        savedDietRepository.deleteByUserIdAndDietPlanId(userId, dietId);
    }

    private Set<UUID> savedIdsOf(UUID userId) {
        Set<UUID> ids = new HashSet<>();
        for (SavedDiet sd : savedDietRepository.findByUserId(userId)) {
            ids.add(sd.getId().getDietPlanId());
        }
        return ids;
    }

    private DietPlanResponse toResponse(DietPlan plan, Set<UUID> savedIds) {
        List<DietMealResponse> meals = dietMealRepository
                .findByDietPlanIdOrderByPositionAsc(plan.getId()).stream()
                .map(DietMealResponse::from)
                .toList();
        return DietPlanResponse.from(plan, meals, savedIds.contains(plan.getId()));
    }

    private DietGoal mapGoal(FitnessGoal fitnessGoal) {
        if (fitnessGoal == null) return null;
        return switch (fitnessGoal) {
            case LOSE_WEIGHT -> DietGoal.LOSE_WEIGHT;
            case GAIN_MUSCLE, INCREASE_STRENGTH -> DietGoal.GAIN_MUSCLE;
            case MAINTAIN, TONE_BODY -> DietGoal.MAINTAIN;
            case IMPROVE_ENDURANCE, REDUCE_STRESS, BETTER_SLEEP,
                 INCREASE_FLEXIBILITY, IMPROVE_POSTURE, INCREASE_ENERGY, BUILD_HABITS -> DietGoal.BALANCED;
        };
    }
}
