package com.zenfit.diet;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "foods")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Food {

    @Id
    @Column(name = "id", columnDefinition = "uuid")
    @Builder.Default
    private UUID id = UUID.randomUUID();

    @Column(name = "name", nullable = false, length = 150)
    private String name;

    @Column(name = "category", nullable = false, length = 60)
    private String category;

    @Column(name = "kcal_per_100g", nullable = false, precision = 6, scale = 2)
    private BigDecimal kcalPer100g;

    @Column(name = "protein_per_100g", nullable = false, precision = 6, scale = 2)
    @Builder.Default
    private BigDecimal proteinPer100g = BigDecimal.ZERO;

    @Column(name = "carbs_per_100g", nullable = false, precision = 6, scale = 2)
    @Builder.Default
    private BigDecimal carbsPer100g = BigDecimal.ZERO;

    @Column(name = "fat_per_100g", nullable = false, precision = 6, scale = 2)
    @Builder.Default
    private BigDecimal fatPer100g = BigDecimal.ZERO;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;
}
