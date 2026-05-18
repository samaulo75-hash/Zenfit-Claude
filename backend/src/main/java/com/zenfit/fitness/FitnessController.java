package com.zenfit.fitness;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.fitness.dto.CreateWorkoutSessionRequest;
import com.zenfit.fitness.dto.ExerciseResponse;
import com.zenfit.fitness.dto.WorkoutResponse;
import com.zenfit.fitness.dto.WorkoutSessionResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class FitnessController {

    private final FitnessService fitnessService;

    @GetMapping("/exercises")
    public List<ExerciseResponse> exercises() {
        return fitnessService.listExercises();
    }

    @GetMapping("/workouts")
    public List<WorkoutResponse> workouts() {
        return fitnessService.listWorkouts();
    }

    @GetMapping("/workouts/{id}")
    public WorkoutResponse workout(@PathVariable UUID id) {
        return fitnessService.getWorkout(id);
    }

    @GetMapping("/workout-sessions")
    public List<WorkoutSessionResponse> sessions(@AuthenticationPrincipal AuthenticatedUser principal,
                                                 @RequestParam(defaultValue = "20") int limit) {
        return fitnessService.listSessions(principal.getId(), Math.min(limit, 100));
    }

    @PostMapping("/workout-sessions")
    public ResponseEntity<WorkoutSessionResponse> createSession(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody CreateWorkoutSessionRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(fitnessService.createSession(principal.getId(), request));
    }
}
