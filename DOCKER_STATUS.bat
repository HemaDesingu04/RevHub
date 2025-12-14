@echo off
echo ========================================
echo   RevHub Docker Status
echo ========================================
echo.

echo [1] Container Status:
echo ----------------------------------------
docker-compose ps
echo.

echo [2] Service Health:
echo ----------------------------------------
echo Checking API Gateway...
curl -s http://localhost:8080/actuator/health | findstr "UP" >nul && echo [OK] API Gateway || echo [FAIL] API Gateway

echo Checking User Service...
curl -s http://localhost:8081/actuator/health | findstr "UP" >nul && echo [OK] User Service || echo [FAIL] User Service

echo Checking Post Service...
curl -s http://localhost:8082/actuator/health | findstr "UP" >nul && echo [OK] Post Service || echo [FAIL] Post Service

echo Checking Social Service...
curl -s http://localhost:8083/actuator/health | findstr "UP" >nul && echo [OK] Social Service || echo [FAIL] Social Service

echo Checking Chat Service...
curl -s http://localhost:8084/actuator/health | findstr "UP" >nul && echo [OK] Chat Service || echo [FAIL] Chat Service

echo Checking Notification Service...
curl -s http://localhost:8085/actuator/health | findstr "UP" >nul && echo [OK] Notification Service || echo [FAIL] Notification Service

echo Checking Feed Service...
curl -s http://localhost:8086/actuator/health | findstr "UP" >nul && echo [OK] Feed Service || echo [FAIL] Feed Service

echo Checking Search Service...
curl -s http://localhost:8087/actuator/health | findstr "UP" >nul && echo [OK] Search Service || echo [FAIL] Search Service

echo Checking Saga Orchestrator...
curl -s http://localhost:8088/actuator/health | findstr "UP" >nul && echo [OK] Saga Orchestrator || echo [FAIL] Saga Orchestrator

echo.
echo [3] Consul Service Registry:
echo ----------------------------------------
echo Open http://localhost:8500 to view registered services
echo.

echo [4] Resource Usage:
echo ----------------------------------------
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
echo.

echo ========================================
pause
