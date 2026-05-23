package com.zenfit.diet;

import com.zenfit.diet.dto.FoodResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/foods")
@RequiredArgsConstructor
public class FoodController {

    private final FoodRepository foodRepository;

    /**
     * Catálogo de alimentos. Si se pasa ?q= filtra por nombre (case-insensitive).
     */
    @GetMapping
    public List<FoodResponse> list(@RequestParam(name = "q", required = false) String q) {
        List<Food> foods = (q == null || q.isBlank())
                ? foodRepository.findAllByOrderByNameAsc()
                : foodRepository.searchByName(q.trim());
        return foods.stream().map(FoodResponse::from).toList();
    }
}
