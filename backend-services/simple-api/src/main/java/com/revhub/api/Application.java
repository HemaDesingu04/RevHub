package com.revhub.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@SpringBootApplication
@RestController
@CrossOrigin(origins = "*")
public class Application {
    
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @GetMapping("/")
    public Map<String, Object> root() {
        return Map.of("message", "RevHub API is running", "status", "UP");
    }

    @GetMapping("/api/health")
    public Map<String, Object> health() {
        return Map.of("status", "UP", "service", "RevHub API");
    }

    @PostMapping("/api/auth/login")
    public Map<String, Object> login(@RequestBody Map<String, Object> request) {
        return Map.of("token", "demo-token", "user", request.get("username"));
    }

    @PostMapping("/api/auth/register")
    public Map<String, Object> register(@RequestBody Map<String, Object> request) {
        return Map.of("message", "User registered", "user", request.get("username"));
    }

    @GetMapping("/api/posts")
    public List<Map<String, Object>> getPosts() {
        return List.of(
            Map.of("id", 1, "content", "Welcome to RevHub!", "author", "admin"),
            Map.of("id", 2, "content", "This is a demo post", "author", "user1")
        );
    }
}