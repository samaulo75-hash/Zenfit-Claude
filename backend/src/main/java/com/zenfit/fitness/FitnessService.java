package com.zenfit.fitness;

import com.zenfit.common.error.NotFoundException;
import com.zenfit.fitness.dto.CreateWorkoutSessionRequest;
import com.zenfit.fitness.dto.ExerciseResponse;
import com.zenfit.fitness.dto.WorkoutExerciseResponse;
import com.zenfit.fitness.dto.WorkoutResponse;
import com.zenfit.fitness.dto.WorkoutSessionResponse;
import com.zenfit.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FitnessService {

    private final ExerciseRepository exerciseRepository;
    private final WorkoutRepository workoutRepository;
    private final WorkoutExerciseRepository workoutExerciseRepository;
    private final WorkoutSessionRepository workoutSessionRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<ExerciseResponse> listExercises() {
        return exerciseRepository.findAll().stream()
                .map(ExerciseResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<WorkoutResponse> listWorkouts() {
        return workoutRepository.findAllByOrderByCreatedAtAsc().stream()
                .map(w -> WorkoutResponse.from(w, exercisesOf(w.getId())))
                .toList();
    }

    @Transactional(readOnly = true)
    public WorkoutResponse getWorkout(UUID workoutId) {
        Workout w = workoutRepository.findById(workoutId)
                .orElseThrow(() -> new NotFoundException("Workout not found"));
        return WorkoutResponse.from(w, exercisesOf(w.getId()));
    }

    private List<WorkoutExerciseResponse> exercisesOf(UUID workoutId) {
        return workoutExerciseRepository.findByWorkoutIdOrderByPositionAsc(workoutId).stream()
                .map(WorkoutExerciseResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<WorkoutSessionResponse> listSessions(UUID userId, int limit) {
        return workoutSessionRepository
                .findByUserIdOrderByStartedAtDesc(userId, PageRequest.of(0, limit))
                .stream()
                .map(WorkoutSessionResponse::from)
                .toList();
    }

    @Transactional
    public WorkoutSessionResponse createSession(UUID userId, CreateWorkoutSessionRequest req) {
        WorkoutSession session = WorkoutSession.builder()
                .user(userRepository.getReferenceById(userId))
                .startedAt(OffsetDateTime.now())
                .completedAt(OffsetDateTime.now())
                .durationSeconds(req.durationSeconds())
                .caloriesBurned(req.caloriesBurned())
                .perceivedEffort(req.perceivedEffort())
                .notes(req.notes())
                .build();

        if (req.workoutId() != null) {
            Workout workout = workoutRepository.findById(req.workoutId())
                    .orElseThrow(() -> new NotFoundException("Workout not found"));
            session.setWorkout(workout);
        }
        return WorkoutSessionResponse.from(workoutSessionRepository.save(session));
    }
}
