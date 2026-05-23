package com.zenfit.diet;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface FoodRepository extends JpaRepository<Food, UUID> {

    @Query("SELECT f FROM Food f WHERE LOWER(f.name) LIKE LOWER(CONCAT('%', :q, '%')) ORDER BY f.name ASC")
    List<Food> searchByName(@Param("q") String q);

    List<Food> findAllByOrderByNameAsc();
}
