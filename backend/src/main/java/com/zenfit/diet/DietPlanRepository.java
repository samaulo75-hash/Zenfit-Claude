package com.zenfit.diet;

import com.zenfit.common.enums.DietGoal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DietPlanRepository extends JpaRepository<DietPlan, UUID> {

    List<DietPlan> findAllByOrderByCreatedAtAsc();

    List<DietPlan> findByGoalOrderByCreatedAtAsc(DietGoal goal);
}
