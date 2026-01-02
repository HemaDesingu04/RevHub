@echo off
echo ========================================
echo Starting RevHub Backend Services (Localhost)
echo ========================================

cd ..

echo [1/9] Starting API Gateway...
start "API Gateway" cmd /k "cd backend-services\api-gateway && mvn spring-boot:run"
timeout /t 5 /nobreak

echo [2/9] Starting User Service...
start "User Service" cmd /k "cd backend-services\user-service && mvn spring-boot:run"
timeout /t 3 /nobreak

echo [3/9] Starting Post Service...
start "Post Service" cmd /k "cd backend-services\post-service && mvn spring-boot:run"
timeout /t 3 /nobreak

echo [4/9] Starting Social Service...
start "Social Service" cmd /k "cd backend-services\social-service && mvn spring-boot:run"
timeout /t 3 /nobreak

echo [5/9] Starting Chat Service...
start "Chat Service" cmd /k "cd backend-services\chat-service && mvn spring-boot:run"
timeout /t 3 /nobreak

echo [6/9] Starting Notification Service...
start "Notification Service" cmd /k "cd backend-services\notification-service && mvn spring-boot:run"
timeout /t 3 /nobreak

echo [7/9] Starting Feed Service...
start "Feed Service" cmd /k "cd backend-services\feed-service && mvn spring-boot:run"
timeout /t 3 /nobreak

echo [8/9] Starting Search Service...
start "Search Service" cmd /k "cd backend-services\search-service && mvn spring-boot:run"
timeout /t 3 /nobreak

echo [9/9] Starting Saga Orchestrator...
start "Saga Orchestrator" cmd /k "cd backend-services\saga-orchestrator && mvn spring-boot:run"

echo.
echo ========================================
echo All backend services are starting...
echo Please wait 60-90 seconds for all services to be ready
echo ========================================
echo API Gateway: http://localhost:8080
echo User Service: http://localhost:8081
echo Post Service: http://localhost:8082
echo Social Service: http://localhost:8083
echo Chat Service: http://localhost:8084
echo Notification Service: http://localhost:8085
echo Feed Service: http://localhost:8086
echo Search Service: http://localhost:8087
echo Saga Orchestrator: http://localhost:8088
echo ========================================
pause