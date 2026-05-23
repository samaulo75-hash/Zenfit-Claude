package com.zenfit.diet;

import com.zenfit.common.error.NotFoundException;
import com.zenfit.diet.dto.CustomDietItemRequest;
import com.zenfit.diet.dto.CustomDietRequest;
import com.zenfit.diet.dto.CustomDietResponse;
import com.zenfit.user.User;
import com.zenfit.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CustomDietService {

    private static final BigDecimal HUNDRED = new BigDecimal("100");

    private final CustomDietRepository customDietRepository;
    private final FoodRepository foodRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<CustomDietResponse> list(UUID userId) {
        User user = userRepository.getReferenceById(userId);
        return customDietRepository.findAllByUserOrderByCreatedAtDesc(user).stream()
                .map(CustomDietResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public CustomDietResponse get(UUID userId, UUID id) {
        User user = userRepository.getReferenceById(userId);
        CustomDiet diet = customDietRepository.findByIdAndUser(id, user)
                .orElseThrow(() -> new NotFoundException("Custom diet not found"));
        return CustomDietResponse.from(diet);
    }

    @Transactional
    public CustomDietResponse create(UUID userId, CustomDietRequest request) {
        User user = userRepository.getReferenceById(userId);
        CustomDiet diet = CustomDiet.builder()
                .user(user)
                .name(request.name().trim())
                .description(request.description() == null ? null : request.description().trim())
                .items(new ArrayList<>())
                .totalKcal(BigDecimal.ZERO)
                .build();
        applyItems(diet, request.items());
        diet = customDietRepository.save(diet);
        return CustomDietResponse.from(diet);
    }

    @Transactional
    public CustomDietResponse update(UUID userId, UUID id, CustomDietRequest request) {
        User user = userRepository.getReferenceById(userId);
        CustomDiet diet = customDietRepository.findByIdAndUser(id, user)
                .orElseThrow(() -> new NotFoundException("Custom diet not found"));

        diet.setName(request.name().trim());
        diet.setDescription(request.description() == null ? null : request.description().trim());
        diet.getItems().clear();
        applyItems(diet, request.items());
        diet = customDietRepository.save(diet);
        return CustomDietResponse.from(diet);
    }

    @Transactional
    public void delete(UUID userId, UUID id) {
        User user = userRepository.getReferenceById(userId);
        CustomDiet diet = customDietRepository.findByIdAndUser(id, user)
                .orElseThrow(() -> new NotFoundException("Custom diet not found"));
        customDietRepository.delete(diet);
    }

    // ---------- helpers ----------

    /**
     * Aplica la lista de items al diet recalculando las kcal de cada item a
     * partir del catálogo (cuando hay foodId) y la suma total.
     */
    private void applyItems(CustomDiet diet, List<CustomDietItemRequest> requests) {
        if (requests == null || requests.isEmpty()) {
            diet.setTotalKcal(BigDecimal.ZERO);
            return;
        }
        BigDecimal total = BigDecimal.ZERO;
        int pos = 0;
        for (CustomDietItemRequest r : requests) {
            CustomDietItem item = CustomDietItem.builder()
                    .customDiet(diet)
                    .grams(r.grams() != null ? r.grams() : BigDecimal.ZERO)
                    .position(pos++)
                    .build();

            if (r.foodId() != null) {
                Food food = foodRepository.findById(r.foodId())
                        .orElseThrow(() -> new NotFoundException("Food not found: " + r.foodId()));
                item.setFood(food);
                item.setFoodNameFreetext(null);
                item.setKcal(computeKcal(food.getKcalPer100g(), item.getGrams()));
            } else {
                // Alimento libre: usamos el nombre y las kcal que envía el cliente
                if (r.foodNameFreetext() == null || r.foodNameFreetext().isBlank()) {
                    throw new IllegalArgumentException("foodId or foodNameFreetext is required");
                }
                item.setFood(null);
                item.setFoodNameFreetext(r.foodNameFreetext().trim());
                item.setKcal(r.kcal() != null ? r.kcal() : BigDecimal.ZERO);
            }

            total = total.add(item.getKcal());
            diet.getItems().add(item);
        }
        diet.setTotalKcal(total.setScale(2, RoundingMode.HALF_UP));
    }

    private BigDecimal computeKcal(BigDecimal kcalPer100g, BigDecimal grams) {
        if (kcalPer100g == null || grams == null) return BigDecimal.ZERO;
        return kcalPer100g.multiply(grams)
                .divide(HUNDRED, 2, RoundingMode.HALF_UP);
    }
}
