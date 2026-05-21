package com.zenfit.diet;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.common.enums.DietGoal;
import com.zenfit.diet.dto.DietPlanResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/diets")
@RequiredArgsConstructor
public class DietController {

    private final DietService dietService;

    @GetMapping
    public List<DietPlanResponse> list(@RequestParam(required = false) DietGoal goal) {
        return dietService.list(goal);
    }

    @GetMapping("/recommended")
    public List<DietPlanResponse> recommended(@AuthenticationPrincipal AuthenticatedUser principal) {
        return dietService.recommendedFor(principal.getId());
    }

    @GetMapping("/{id}")
    public DietPlanResponse get(@PathVariable UUID id) {
        return dietService.get(id);
    }
}
