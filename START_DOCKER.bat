@echo off
echo ========================================
echo   RevHub - Docker Containerized Setup
echo ========================================
echo.

echo [1/4] Building shared modules...
cd shared
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to build shared modules
    pause
    exit /b 1
)
cd ..

echo.
echo [2/4] Building all backend services...
for %%s in (api-gateway user-service post-service social-service chat-service notification-service feed-service search-service saga-orchestrator) do (
    echo Building %%s...
    cd backend-services\%%s
    call mvn clean package -DskipTests
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Failed to build %%s
        cd ..\..
        pause
        exit /b 1
    )
    cd ..\..
)

echo.
echo [3/4] Stopping existing containers...
docker-compose down

echo.
echo [4/4] Starting backend services in Docker...
docker-compose up -d --build

echo.
echo ========================================
echo   Waiting for services to start...
echo ========================================
timeout /t 45 /nobreak

echo.
echo ========================================
echo   RevHub Services Status
echo ========================================
docker-compose ps

echo.
echo ========================================
echo   Access Points:
echo ========================================
echo   Frontend:        http://localhost:4200
echo   API Gateway:     http://localhost:8090
echo   Consul UI:       http://localhost:8500
echo   User Service:    http://localhost:8081
echo   Post Service:    http://localhost:8082
echo   Social Service:  http://localhost:8083
echo   Chat Service:    http://localhost:8084
echo   Notification:    http://localhost:8085
echo   Feed Service:    http://localhost:8086
echo   Search Service:  http://localhost:8087
echo   Saga Service:    http://localhost:8088
echo ========================================
echo.
echo To view logs: docker-compose logs -f [service-name]
echo To stop all:  docker-compose down
echo.
pause
