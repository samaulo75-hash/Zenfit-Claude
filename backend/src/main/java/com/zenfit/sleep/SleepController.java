package com.zenfit.sleep;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.sleep.dto.SaveSleepLogRequest;
import com.zenfit.sleep.dto.SleepLogResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/sleep-logs")
@RequiredArgsConstructor
public class SleepController {

    private final SleepService sleepService;

    @GetMapping
    public List<SleepLogResponse> list(@AuthenticationPrincipal AuthenticatedUser principal,
                                       @RequestParam(defaultValue = "30") int limit) {
        return sleepService.list(principal.getId(), Math.min(limit, 365));
    }

    @PostMapping
    public ResponseEntity<SleepLogResponse> save(@AuthenticationPrincipal AuthenticatedUser principal,
                                                 @Valid @RequestBody SaveSleepLogRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(sleepService.save(principal.getId(), request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@AuthenticationPrincipal AuthenticatedUser principal,
                                       @PathVariable UUID id) {
        sleepService.delete(principal.getId(), id);
        return ResponseEntity.noContent().build();
    }
}
