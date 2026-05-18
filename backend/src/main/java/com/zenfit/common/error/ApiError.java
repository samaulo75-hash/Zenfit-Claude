package com.zenfit.common.error;

import org.springframework.http.HttpStatus;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

public record ApiError(
        OffsetDateTime timestamp,
        int status,
        String error,
        String message,
        String path,
        Map<String, List<String>> fieldErrors
) {
    public static ApiError of(HttpStatus status, String message, String path) {
        return new ApiError(OffsetDateTime.now(), status.value(), status.getReasonPhrase(), message, path, null);
    }

    public static ApiError validation(String message, String path, Map<String, List<String>> fieldErrors) {
        return new ApiError(OffsetDateTime.now(), HttpStatus.BAD_REQUEST.value(),
                HttpStatus.BAD_REQUEST.getReasonPhrase(), message, path, fieldErrors);
    }
}
