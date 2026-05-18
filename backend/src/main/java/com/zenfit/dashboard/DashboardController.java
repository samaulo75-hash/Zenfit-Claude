package com.zenfit.dashboard;

import com.zenfit.auth.service.AuthenticatedUser;
import com.zenfit.dashboard.dto.DashboardResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping
    public DashboardResponse dashboard(@AuthenticationPrincipal AuthenticatedUser principal) {
        return dashboardService.build(principal.getId());
    }
}
