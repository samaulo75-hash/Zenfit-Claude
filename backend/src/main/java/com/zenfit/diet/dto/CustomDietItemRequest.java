package com.zenfit.diet.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Item de una dieta personalizada. O bien viene foodId (alimento del catálogo)
 * y kcal se recalcula a partir de grams, o bien viene foodNameFreetext + kcal
 * a mano (alimento libre que el usuario introduce).
 */
public record CustomDietItemRequest(
        UUID foodId,

        @Size(max = 150)
        String foodNameFreetext,

        @NotNull @DecimalMin(value = "0.0", inclusive = true)
        BigDecimal grams,

        /** Solo se usa cuando foodId == null (alimento libre). */
        @DecimalMin(value = "0.0", inclusive = true)
        BigDecimal kcal
) {}
