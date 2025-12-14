# 🔧 RevHub - Complete Rebuild and Run Guide

## 📋 Overview

This guide provides step-by-step instructions to rebuild and run each module individually or all at once.

## 🎯 Three Ways to Build and Run

### Option 1: Automated Full Rebuild and Run (Recommended)
```bash
REBUILD_AND_RUN_ALL.bat
```
This will:
- Clean all previous builds
- Build all 3 shared modules
- Start infrastructure
- Build and start all 9 backend services
- Build and start all 6 frontend services
- Run health checks

**Time:** ~45-60 minutes

---

### Option 2: Sequential Individual Rebuilds
```bash
cd rebuild-modules
RUN-ALL-SEQUENTIALLY.bat
```
This will rebuild all modules one by one, then you manually start services.

**Time:** ~30-40 minutes (build only)

---

### Option 3: Manual Individual Module Rebuild

Navigate to `rebuild-modules` directory and run scripts individually:

```bash
cd rebuild-modules
```

#### Step 1: Shared Modules (REQUIRED FIRST)
```bash
01-rebuild-shared-modules.bat
```
Builds:
- common-dto
- event-schemas
- utilities

#### Step 2-10: Backend Services
```bash
02-rebuild-user-service.bat
03-rebuild-post-service.bat
04-rebuild-social-service.bat
05-rebuild-chat-service.bat
06-rebuild-notification-service.bat
07-rebuild-feed-service.bat
08-rebuild-search-service.bat
09-rebuild-saga-orchestrator.bat
10-rebuild-api-gateway.bat
```

#### Step 11-16: Frontend Services
```bash
11-rebuild-shell-app.bat
12-rebuild-auth-microfrontend.bat
13-rebuild-feed-microfrontend.bat
14-rebuild-profile-microfrontend.bat
15-rebuild-chat-microfrontend.bat
16-rebuild-notifications-microfrontend.bat
```

---

## 🚀 Running Services After Build

### 1. Start Infrastructure
```bash
cd scripts
start-infrastructure.bat
```
Starts:
- Consul (8500)
- Kafka (9092)
- MySQL (3306)
- MongoDB (27017)

Wait 30 seconds for infrastructure to be ready.

### 2. Start Backend Services

#### Option A: Start All Backend Services
```bash
cd scripts
start-backend-services.bat
```

#### Option B: Start Individual Backend Services
```bash
# User Service (8081)
cd backend-services\user-service
mvn spring-boot:run

# Post Service (8082)
cd backend-services\post-service
mvn spring-boot:run

# Social Service (8083)
cd backend-services\social-service
mvn spring-boot:run

# Chat Service (8084)
cd backend-services\chat-service
mvn spring-boot:run

# Notification Service (8085)
cd backend-services\notification-service
mvn spring-boot:run

# Feed Service (8086)
cd backend-services\feed-service
mvn spring-boot:run

# Search Service (8087)
cd backend-services\search-service
mvn spring-boot:run

# Saga Orchestrator (8088)
cd backend-services\saga-orchestrator
mvn spring-boot:run

# API Gateway (8080)
cd backend-services\api-gateway
mvn spring-boot:run
```

### 3. Start Frontend Services

#### Option A: Start All Frontend Services
```bash
cd scripts
start-all-frontends.bat
```

#### Option B: Start Individual Frontend Services
```bash
# Shell App (4200)
cd frontend-services\shell-app
npm start

# Auth Microfrontend (4201)
cd frontend-services\auth-microfrontend
npm start

# Feed Microfrontend (4202)
cd frontend-services\feed-microfrontend
npm start

# Profile Microfrontend (4203)
cd frontend-services\profile-microfrontend
npm start

# Chat Microfrontend (4204)
cd frontend-services\chat-microfrontend
npm start

# Notifications Microfrontend (4205)
cd frontend-services\notifications-microfrontend
npm start
```

---

## 🔍 Health Checks

### Check All Services
```bash
cd scripts
health-check.bat
```

### Manual Health Checks
```bash
# Backend Services
curl http://localhost:8080/actuator/health  # API Gateway
curl http://localhost:8081/actuator/health  # User Service
curl http://localhost:8082/actuator/health  # Post Service
curl http://localhost:8083/actuator/health  # Social Service
curl http://localhost:8084/actuator/health  # Chat Service
curl http://localhost:8085/actuator/health  # Notification Service
curl http://localhost:8086/actuator/health  # Feed Service
curl http://localhost:8087/actuator/health  # Search Service
curl http://localhost:8088/actuator/health  # Saga Orchestrator

# Frontend Services
curl http://localhost:4200  # Shell App
curl http://localhost:4201  # Auth Microfrontend
curl http://localhost:4202  # Feed Microfrontend
curl http://localhost:4203  # Profile Microfrontend
curl http://localhost:4204  # Chat Microfrontend
curl http://localhost:4205  # Notifications Microfrontend

# Infrastructure
curl http://localhost:8500/v1/status/leader  # Consul
```

---

## 📊 Module Build Times (Approximate)

| Module | Build Time |
|--------|-----------|
| Shared Modules | 2-3 min |
| Each Backend Service | 1-2 min |
| Each Frontend Service | 2-3 min |
| **Total Sequential** | 30-40 min |

---

## 🌐 Access Points

| Service | URL | Port |
|---------|-----|------|
| **Main Application** | http://localhost:4200 | 4200 |
| **API Gateway** | http://localhost:8080 | 8080 |
| **Consul UI** | http://localhost:8500 | 8500 |
| User Service | http://localhost:8081 | 8081 |
| Post Service | http://localhost:8082 | 8082 |
| Social Service | http://localhost:8083 | 8083 |
| Chat Service | http://localhost:8084 | 8084 |
| Notification Service | http://localhost:8085 | 8085 |
| Feed Service | http://localhost:8086 | 8086 |
| Search Service | http://localhost:8087 | 8087 |
| Saga Orchestrator | http://localhost:8088 | 8088 |
| Auth Microfrontend | http://localhost:4201 | 4201 |
| Feed Microfrontend | http://localhost:4202 | 4202 |
| Profile Microfrontend | http://localhost:4203 | 4203 |
| Chat Microfrontend | http://localhost:4204 | 4204 |
| Notifications Microfrontend | http://localhost:4205 | 4205 |

---

## 🛠️ Troubleshooting

### Build Failures

#### Shared Module Build Failed
```bash
cd shared\[module-name]
mvn clean install -X  # Verbose output
```

#### Backend Service Build Failed
```bash
cd backend-services\[service-name]
mvn clean package -X  # Verbose output
```

#### Frontend Build Failed
```bash
cd frontend-services\[service-name]
rmdir /s /q node_modules
npm cache clean --force
npm install
```

### Port Already in Use
```bash
netstat -ano | findstr :[PORT]
taskkill /PID [PID] /F
```

### Service Won't Start
1. Check if infrastructure is running
2. Check if shared modules are built
3. Check logs in service window
4. Verify database connections

### Clean Everything and Start Fresh
```bash
cd scripts
clean-all.bat
docker-compose down -v
docker system prune -f
```

---

## 📝 Build Order Dependencies

```
Shared Modules (common-dto, event-schemas, utilities)
    ↓
Backend Services (any order)
    ↓
API Gateway (last backend service)
    ↓
Frontend Services (any order)
```

---

## ✅ Success Checklist

- [ ] All 3 shared modules built successfully
- [ ] All 9 backend services built successfully
- [ ] All 6 frontend services built successfully
- [ ] Infrastructure running (Consul, Kafka, MySQL, MongoDB)
- [ ] All backend services responding to health checks
- [ ] All frontend services accessible
- [ ] Main application loads at http://localhost:4200
- [ ] Can register and login
- [ ] Can create and view posts

---

## 🎯 Quick Start Commands

### Full Automated Build and Run
```bash
REBUILD_AND_RUN_ALL.bat
```

### Build Only (No Run)
```bash
cd rebuild-modules
RUN-ALL-SEQUENTIALLY.bat
```

### Run After Build
```bash
cd scripts
start-infrastructure.bat
start-backend-services.bat
start-all-frontends.bat
```

### Stop Everything
```bash
cd scripts
stop-all.bat
```

---

## 📞 Need Help?

1. Check service logs in individual windows
2. Run health checks: `cd scripts && health-check.bat`
3. Check infrastructure: http://localhost:8500
4. Review error messages in build output

---

**Built with ❤️ using Spring Boot, Angular, and Microservices Architecture**
