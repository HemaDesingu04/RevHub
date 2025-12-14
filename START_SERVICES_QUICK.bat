@echo off
echo ========================================
echo Starting RevHub Services (Quick Start)
echo ========================================
echo.

echo Step 1: Starting Docker Infrastructure...
cd infrastructure
docker-compose up -d
echo Waiting for services to be ready...
timeout /t 10 /nobreak >nul
echo.

echo Step 2: Starting API Gateway...
cd ..\backend-services\api-gateway
start "API Gateway" cmd /k "java -jar target\api-gateway-1.0.0.jar"
timeout /t 5 /nobreak >nul
echo.

echo Step 3: Starting Search Service...
cd ..\search-service
start "Search Service" cmd /k "java -jar target\search-service-1.0.0.jar"
timeout /t 3 /nobreak >nul
echo.

echo ========================================
echo Services Started!
echo ========================================
echo API Gateway: http://localhost:8080
echo Consul UI: http://localhost:8500
echo Search Service: http://localhost:8087
echo ========================================
pause
