package com.zenfit.sleep;

import com.zenfit.common.error.NotFoundException;
import com.zenfit.sleep.dto.SaveSleepLogRequest;
import com.zenfit.sleep.dto.SleepLogResponse;
import com.zenfit.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SleepService {

    private final SleepLogRepository sleepLogRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<SleepLogResponse> list(UUID userId, int limit) {
        return sleepLogRepository
                .findByUserIdOrderBySleepDateDesc(userId, PageRequest.of(0, limit))
                .stream()
                .map(SleepLogResponse::from)
                .toList();
    }

    /** Upsert: si ya existe un registro para esa fecha, lo actualiza. */
    @Transactional
    public SleepLogResponse save(UUID userId, SaveSleepLogRequest req) {
        SleepLog log = sleepLogRepository.findByUserIdAndSleepDate(userId, req.sleepDate())
                .orElseGet(() -> {
                    SleepLog s = new SleepLog();
                    s.setUser(userRepository.getReferenceById(userId));
                    s.setSleepDate(req.sleepDate());
                    return s;
                });
        log.setDurationMinutes(req.durationMinutes());
        log.setQuality(req.quality());
        log.setNotes(req.notes());
        return SleepLogResponse.from(sleepLogRepository.save(log));
    }

    @Transactional
    public void delete(UUID userId, UUID id) {
        SleepLog log = sleepLogRepository.findByIdAndUserId(id, userId)
                .orElseThrow(() -> new NotFoundException("Sleep log not found"));
        sleepLogRepository.delete(log);
    }
}
