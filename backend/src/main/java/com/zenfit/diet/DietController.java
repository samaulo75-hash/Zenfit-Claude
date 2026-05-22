package com.zenfit.diet;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.common.enums.DietGoal;
import com.zenfit.diet.dto.DietPlanResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
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
    public List<DietPlanResponse> list(@AuthenticationPrincipal AuthenticatedUser principal,
                                       @RequestParam(required = false) DietGoal goal) {
        return dietService.list(principal.getId(), goal);
    }

    @GetMapping("/recommended")
    public List<DietPlanResponse> recommended(@AuthenticationPrincipal AuthenticatedUser principal) {
        return dietService.recommendedFor(principal.getId());
    }

    @GetMapping("/saved")
    public List<DietPlanResponse> saved(@AuthenticationPrincipal AuthenticatedUser principal) {
        return dietService.listSaved(principal.getId());
    }

    @GetMapping("/{id}")
    public DietPlanResponse get(@AuthenticationPrincipal AuthenticatedUser principal,
                                @PathVariable UUID id) {
        return dietService.get(principal.getId(), id);
    }

    @PostMapping("/{id}/save")
    public ResponseEntity<Void> save(@AuthenticationPrincipal AuthenticatedUser principal,
                                     @PathVariable UUID id) {
        dietService.save(principal.getId(), id);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}/save")
    public ResponseEntity<Void> unsave(@AuthenticationPrincipal AuthenticatedUser principal,
                                       @PathVariable UUID id) {
        dietService.unsave(principal.getId(), id);
        return ResponseEntity.noContent().build();
    }
}
