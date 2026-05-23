package com.zenfit.diet;

import com.zenfit.user.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface CustomDietRepository extends JpaRepository<CustomDiet, UUID> {

    @EntityGraph(attributePaths = {"items", "items.food"})
    List<CustomDiet> findAllByUserOrderByCreatedAtDesc(User user);

    @EntityGraph(attributePaths = {"items", "items.food"})
    Optional<CustomDiet> findByIdAndUser(UUID id, User user);
}
