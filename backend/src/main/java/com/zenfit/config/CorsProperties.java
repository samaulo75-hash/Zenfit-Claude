package com.zenfit.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.List;

@ConfigurationProperties(prefix = "zenfit.cors")
public record CorsProperties(List<String> allowedOrigins) {}
