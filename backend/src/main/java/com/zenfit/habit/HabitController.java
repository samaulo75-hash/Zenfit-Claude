package com.zenfit.habit;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.habit.dto.CreateHabitRequest;
import com.zenfit.habit.dto.HabitResponse;
import com.zenfit.habit.dto.UpdateHabitRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
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

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/habits")
@RequiredArgsConstructor
public class HabitController {

    private final HabitService habitService;

    @GetMapping
    public List<HabitResponse> list(@AuthenticationPrincipal AuthenticatedUser principal) {
        return habitService.list(principal.getId());
    }

    @PostMapping
    public ResponseEntity<HabitResponse> create(@AuthenticationPrincipal AuthenticatedUser principal,
                                                @Valid @RequestBody CreateHabitRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(habitService.create(principal.getId(), request));
    }

    @PutMapping("/{id}")
    public HabitResponse update(@AuthenticationPrincipal AuthenticatedUser principal,
                                @PathVariable UUID id,
                                @Valid @RequestBody UpdateHabitRequest request) {
        return habitService.update(principal.getId(), id, request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@AuthenticationPrincipal AuthenticatedUser principal,
                                       @PathVariable UUID id) {
        habitService.delete(principal.getId(), id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/toggle")
    public HabitResponse toggle(@AuthenticationPrincipal AuthenticatedUser principal,
                                @PathVariable UUID id,
                                @RequestParam(required = false)
                                @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return habitService.toggle(principal.getId(), id, date);
    }
}
