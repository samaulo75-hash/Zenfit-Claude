package com.zenfit.diet;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "custom_diet_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomDietItem {

    @Id
    @Column(name = "id", columnDefinition = "uuid")
    @Builder.Default
    private UUID id = UUID.randomUUID();

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "custom_diet_id", nullable = false)
    private CustomDiet customDiet;

    /** Si está presente, kcal se recalcula a partir del catálogo. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "food_id")
    private Food food;

    /** Nombre libre cuando el alimento no está en el catálogo. */
    @Column(name = "food_name_freetext", length = 150)
    private String foodNameFreetext;

    @Column(name = "grams", nullable = false, precision = 7, scale = 2)
    private BigDecimal grams;

    @Column(name = "kcal", nullable = false, precision = 7, scale = 2)
    private BigDecimal kcal;

    @Column(name = "position", nullable = false)
    @Builder.Default
    private int position = 0;
}
