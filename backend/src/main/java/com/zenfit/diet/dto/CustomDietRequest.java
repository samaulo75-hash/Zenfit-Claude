package com.zenfit.diet.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.List;

public record CustomDietRequest(
        @NotBlank @Size(max = 120)
        String name,

        @Size(max = 1000)
        String description,

        @Valid
        List<CustomDietItemRequest> items
) {}
