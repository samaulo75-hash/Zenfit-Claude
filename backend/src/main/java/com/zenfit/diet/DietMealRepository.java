package com.zenfit.diet;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DietMealRepository extends JpaRepository<DietMeal, UUID> {

    List<DietMeal> findByDietPlanIdOrderByPositionAsc(UUID dietPlanId);
}
