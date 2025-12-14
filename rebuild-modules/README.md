# 🔧 Rebuild Modules - Individual Scripts

This directory contains individual rebuild scripts for each module in the RevHub Microservices platform.

## 📋 Execution Order

### Phase 1: Shared Modules (Required First)
1. **01-rebuild-shared-modules.bat** - Builds common-dto, event-schemas, utilities

### Phase 2: Backend Services
2. **02-rebuild-user-service.bat** - User management (Port 8081)
3. **03-rebuild-post-service.bat** - Post management (Port 8082)
4. **04-rebuild-social-service.bat** - Social features (Port 8083)
5. **05-rebuild-chat-service.bat** - Chat messaging (Port 8084)
6. **06-rebuild-notification-service.bat** - Notifications (Port 8085)
7. **07-rebuild-feed-service.bat** - Feed aggregation (Port 8086)
8. **08-rebuild-search-service.bat** - Search functionality (Port 8087)
9. **09-rebuild-saga-orchestrator.bat** - Distributed transactions (Port 8088)
10. **10-rebuild-api-gateway.bat** - API Gateway (Port 8080)

### Phase 3: Frontend Services
11. **11-rebuild-shell-app.bat** - Main container app (Port 4200)
12. **12-rebuild-auth-microfrontend.bat** - Authentication UI (Port 4201)
13. **13-rebuild-feed-microfrontend.bat** - Feed UI (Port 4202)
14. **14-rebuild-profile-microfrontend.bat** - Profile UI (Port 4203)
15. **15-rebuild-chat-microfrontend.bat** - Chat UI (Port 4204)
16. **16-rebuild-notifications-microfrontend.bat** - Notifications UI (Port 4205)

## 🚀 Usage

### Rebuild All Modules
```bash
cd rebuild-modules
01-rebuild-shared-modules.bat
02-rebuild-user-service.bat
03-rebuild-post-service.bat
... (continue with all scripts)
```

### Rebuild Single Module
```bash
cd rebuild-modules
03-rebuild-post-service.bat
```

### Start After Rebuild
Each script shows the command to start the service:
```bash
cd ..\backend-services\[service-name]
mvn spring-boot:run
```

Or for frontend:
```bash
cd ..\frontend-services\[service-name]
npm start
```

## ⚠️ Prerequisites

### Before Running Backend Scripts:
- Java 17+ installed
- Maven 3.8+ installed
- Shared modules built (run script 01 first)

### Before Running Frontend Scripts:
- Node.js 18+ installed
- npm installed

## 📝 Notes

- Always build shared modules first (script 01)
- Backend services can be built in any order after shared modules
- Frontend services can be built in parallel
- Each script includes error handling and success messages
- Scripts return to rebuild-modules directory after completion

## 🔄 Automated Alternative

For automated rebuild and run of all modules:
```bash
cd ..
REBUILD_AND_RUN_ALL.bat
```

This will execute all steps automatically with proper timing and health checks.
