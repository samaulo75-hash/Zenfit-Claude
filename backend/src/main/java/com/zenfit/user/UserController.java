package com.zenfit.user;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.user.dto.UpdateWellnessProfileRequest;
import com.zenfit.user.dto.UserResponse;
import com.zenfit.user.dto.WellnessProfileResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/users/me")
@RequiredArgsConstructor
public class UserController {

    private final WellnessProfileService profileService;

    @GetMapping
    public ResponseEntity<UserResponse> me(@AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(UserResponse.from(principal.getUser()));
    }

    @GetMapping("/profile")
    public ResponseEntity<WellnessProfileResponse> getProfile(@AuthenticationPrincipal AuthenticatedUser principal) {
        return ResponseEntity.ok(profileService.get(principal.getId()));
    }

    @PutMapping("/profile")
    public ResponseEntity<WellnessProfileResponse> updateProfile(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody UpdateWellnessProfileRequest request) {
        return ResponseEntity.ok(profileService.update(principal.getId(), request));
    }
}
