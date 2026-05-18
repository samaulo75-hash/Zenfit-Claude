package com.zenfit.user;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface WellnessProfileRepository extends JpaRepository<WellnessProfile, UUID> {

    Optional<WellnessProfile> findByUserId(UUID userId);
}
