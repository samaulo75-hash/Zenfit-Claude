package com.zenfit.diet;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

public interface SavedDietRepository extends JpaRepository<SavedDiet, SavedDietId> {

    List<SavedDiet> findByUserId(UUID userId);

    boolean existsByUserIdAndDietPlanId(UUID userId, UUID dietPlanId);

    @Transactional
    void deleteByUserIdAndDietPlanId(UUID userId, UUID dietPlanId);
}
