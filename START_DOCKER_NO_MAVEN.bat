@echo off
echo ========================================
echo   RevHub - Docker Setup (No Maven Required)
echo ========================================
echo.

echo [1/2] Stopping existing containers...
docker-compose down

echo.
echo [2/2] Building and starting all services in Docker...
docker-compose up -d --build

echo.
echo ========================================
echo   Waiting for services to start...
echo ========================================
timeout /t 60 /nobreak

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
echo   API Gateway:     http://localhost:8080
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