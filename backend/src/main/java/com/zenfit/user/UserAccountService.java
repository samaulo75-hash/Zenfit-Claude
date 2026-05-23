package com.zenfit.user;

import com.zenfit.common.error.NotFoundException;
import com.zenfit.diet.CustomDietRepository;
import com.zenfit.diet.dto.CustomDietResponse;
import com.zenfit.habit.Habit;
import com.zenfit.habit.HabitRepository;
import com.zenfit.fitness.WorkoutSessionRepository;
import com.zenfit.fitness.dto.WorkoutSessionResponse;
import com.zenfit.sleep.SleepLogRepository;
import com.zenfit.sleep.dto.SleepLogResponse;
import com.zenfit.user.dto.UpdateUserRequest;
import com.zenfit.user.dto.UserResponse;
import com.zenfit.user.dto.WellnessProfileResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Operaciones de "mi cuenta": actualizar datos básicos, exportar todos los datos
 * en JSON y eliminar la cuenta. La eliminación se apoya en los ON DELETE CASCADE
 * de las migraciones (refresh_tokens, password_reset_tokens, wellness_profiles,
 * habits + habit_logs, sleep_logs, workout_sessions, custom_diets + items, etc.).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserAccountService {

    private final UserRepository userRepository;
    private final WellnessProfileService profileService;
    private final HabitRepository habitRepository;
    private final SleepLogRepository sleepLogRepository;
    private final WorkoutSessionRepository workoutSessionRepository;
    private final CustomDietRepository customDietRepository;

    @Transactional
    public UserResponse updateBasicInfo(UUID userId, UpdateUserRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));
        user.setFullName(request.fullName().trim());
        return UserResponse.from(userRepository.save(user));
    }

    @Transactional
    public void deleteAccount(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));
        log.info("Deleting account for user {} ({}). Cascade removes all related data.", user.getEmail(), userId);
        userRepository.delete(user);
    }

    /**
     * Devuelve todos los datos personales del usuario en un Map serializable a
     * JSON: usuario, perfil de bienestar, hábitos, sueño, sesiones de
     * entrenamiento y dietas personalizadas.
     */
    @Transactional(readOnly = true)
    public Map<String, Object> exportData(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));

        Map<String, Object> dump = new LinkedHashMap<>();
        dump.put("exportedAt", OffsetDateTime.now());
        dump.put("schemaVersion", 1);

        dump.put("user", UserResponse.from(user));

        WellnessProfileResponse profile = profileService.get(userId);
        dump.put("wellnessProfile", profile);

        dump.put("habits", habitRepository.findByUserIdOrderByCreatedAtAsc(userId).stream()
                .map(UserAccountService::habitToMap)
                .toList());

        dump.put("sleepLogs", sleepLogRepository
                .findByUserIdOrderBySleepDateDesc(userId, PageRequest.of(0, 1000)).stream()
                .map(SleepLogResponse::from)
                .toList());

        dump.put("workoutSessions", workoutSessionRepository
                .findByUserIdOrderByStartedAtDesc(userId, PageRequest.of(0, 1000)).stream()
                .map(WorkoutSessionResponse::from)
                .toList());

        dump.put("customDiets", customDietRepository
                .findAllByUserOrderByCreatedAtDesc(user).stream()
                .map(CustomDietResponse::from)
                .toList());

        return dump;
    }

    /**
     * Serializa un Habit a un Map para el export — evita depender del
     * HabitService (que añade datos derivados que no nos hacen falta aquí).
     */
    private static Map<String, Object> habitToMap(Habit h) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", h.getId());
        m.put("name", h.getName());
        m.put("description", h.getDescription());
        m.put("frequency", h.getFrequency());
        m.put("targetPerPeriod", h.getTargetPerPeriod());
        m.put("color", h.getColor());
        m.put("icon", h.getIcon());
        m.put("active", h.isActive());
        m.put("createdAt", h.getCreatedAt());
        return m;
    }
}
