package com.revhub.apigateway.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class HealthController {
    
    @GetMapping("/")
    public Map<String, String> root() {
        return Map.of(
            "service", "RevHub API Gateway",
            "status", "UP",
            "version", "1.0.0"
        );
    }
}