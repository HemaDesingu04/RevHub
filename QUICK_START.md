# 🚀 RevHub Quick Start Guide

## Prerequisites
- Java 17+
- Maven 3.8+
- Node.js 18+
- Docker Desktop running

## Step-by-Step Startup

### 1️⃣ Build Backend Services (5-10 minutes)
```bash
cd c:\Users\dodda\RevHub-Microservices\scripts
build-all-services.bat
```
**Expected**: 9 JAR files created in each service's target/ folder

### 2️⃣ Start Infrastructure (2 minutes)
```bash
cd c:\Users\dodda\RevHub-Microservices\scripts
start-infrastructure.bat
```
**Verify**:
- Consul UI: http://localhost:8500
- Wait for script to complete

### 3️⃣ Start Backend Services (3-5 minutes)
```bash
cd c:\Users\dodda\RevHub-Microservices\scripts
start-backend-services.bat
```
**Verify**:
- API Gateway: http://localhost:8080/actuator/health
- Check all services in Consul UI

### 4️⃣ Start Frontend Services (5-10 minutes)
```bash
cd c:\Users\dodda\RevHub-Microservices\scripts
start-all-frontends.bat
```
**This opens 6 terminal windows**:
- Shell App: http://localhost:4200
- Auth: http://localhost:4201
- Feed: http://localhost:4202
- Profile: http://localhost:4203
- Chat: http://localhost:4204
- Notifications: http://localhost:4205

### 5️⃣ Access Application
Open browser: **http://localhost:4200**

## Test User Flow
1. Register new user
2. Login
3. Create a post
4. View feed
5. Test chat
6. Check notifications

## Stop Everything
```bash
# Stop backend
docker-compose down

# Stop frontends
# Press Ctrl+C in each terminal window
```

## Troubleshooting

### Ports Already in Use
```bash
netstat -ano | findstr :8080
# Kill process if needed
```

### Docker Issues
```bash
docker-compose down -v
docker system prune -f
```

### Frontend Build Errors
```bash
cd frontend-services\[service-name]
rmdir /s node_modules
npm cache clean --force
npm install
```

## Service Ports
- API Gateway: 8080
- User Service: 8081
- Post Service: 8082
- Social Service: 8083
- Chat Service: 8084
- Notification Service: 8085
- Feed Service: 8086
- Search Service: 8087
- Saga Orchestrator: 8088
- Consul: 8500
- MySQL: 3306
- MongoDB: 27017
- Kafka: 9092

## Success Checklist
✅ All backend services running in Docker
✅ All services registered in Consul
✅ All 6 frontend terminals running
✅ Can access http://localhost:4200
✅ Can register and login
✅ Can create and view posts
