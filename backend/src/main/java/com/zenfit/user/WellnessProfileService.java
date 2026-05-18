package com.zenfit.user;

import com.zenfit.common.enums.ActivityLevel;
import com.zenfit.user.dto.UpdateWellnessProfileRequest;
import com.zenfit.user.dto.WellnessProfileResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WellnessProfileService {

    private final WellnessProfileRepository profileRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public WellnessProfileResponse get(UUID userId) {
        WellnessProfile profile = profileRepository.findByUserId(userId)
                .orElseGet(() -> emptyProfileFor(userId));
        return WellnessProfileResponse.from(profile);
    }

    @Transactional
    public WellnessProfileResponse update(UUID userId, UpdateWellnessProfileRequest req) {
        WellnessProfile profile = profileRepository.findByUserId(userId)
                .orElseGet(() -> {
                    User user = userRepository.getReferenceById(userId);
                    WellnessProfile p = new WellnessProfile();
                    p.setUser(user);
                    p.setActivityLevel(ActivityLevel.MODERATE);
                    return p;
                });

        profile.setDateOfBirth(req.dateOfBirth());
        profile.setGender(req.gender());
        profile.setHeightCm(req.heightCm());
        profile.setWeightKg(req.weightKg());
        profile.setFitnessGoal(req.fitnessGoal());
        if (req.activityLevel() != null) {
            profile.setActivityLevel(req.activityLevel());
        }
        profile.setMedicalNotes(req.medicalNotes());

        return WellnessProfileResponse.from(profileRepository.save(profile));
    }

    private WellnessProfile emptyProfileFor(UUID userId) {
        WellnessProfile p = new WellnessProfile();
        p.setUser(userRepository.getReferenceById(userId));
        p.setActivityLevel(ActivityLevel.MODERATE);
        return p;
    }
}
