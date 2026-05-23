package com.zenfit.diet;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.common.enums.DietGoal;
import com.zenfit.diet.dto.CustomDietRequest;
import com.zenfit.diet.dto.CustomDietResponse;
import com.zenfit.diet.dto.DietPlanResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
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
    private final CustomDietService customDietService;

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

    // =============================================================
    // Dietas personalizadas del usuario
    // =============================================================

    @GetMapping("/mine")
    public List<CustomDietResponse> mine(@AuthenticationPrincipal AuthenticatedUser principal) {
        return customDietService.list(principal.getId());
    }

    @GetMapping("/mine/{id}")
    public CustomDietResponse getMine(@AuthenticationPrincipal AuthenticatedUser principal,
                                      @PathVariable UUID id) {
        return customDietService.get(principal.getId(), id);
    }

    @PostMapping("/mine")
    public ResponseEntity<CustomDietResponse> createMine(@AuthenticationPrincipal AuthenticatedUser principal,
                                                         @Valid @RequestBody CustomDietRequest request) {
        CustomDietResponse created = customDietService.create(principal.getId(), request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/mine/{id}")
    public CustomDietResponse updateMine(@AuthenticationPrincipal AuthenticatedUser principal,
                                         @PathVariable UUID id,
                                         @Valid @RequestBody CustomDietRequest request) {
        return customDietService.update(principal.getId(), id, request);
    }

    @DeleteMapping("/mine/{id}")
    public ResponseEntity<Void> deleteMine(@AuthenticationPrincipal AuthenticatedUser principal,
                                           @PathVariable UUID id) {
        customDietService.delete(principal.getId(), id);
        return ResponseEntity.noContent().build();
    }
}
