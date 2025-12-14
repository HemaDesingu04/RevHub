@echo off
echo ========================================
echo Restarting User Service with Updated Code
echo ========================================

echo.
echo Step 1: Checking if MySQL is running...
docker ps | findstr mysql
if errorlevel 1 (
    echo MySQL is not running! Starting infrastructure...
    cd infrastructure
    docker-compose up -d
    cd ..
    echo Waiting for MySQL to be ready...
    timeout /t 15 /nobreak
)

echo.
echo Step 2: Stopping old user-service...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8081') do (
    taskkill /PID %%a /F 2>nul
)

echo.
echo Step 3: Starting updated user-service...
cd backend-services\user-service
start /B java -jar target/user-service-1.0.0.jar

echo.
echo ========================================
echo User Service is starting...
echo Wait 15-20 seconds for it to be ready
echo Then refresh your browser to see the follower/following counts
echo ========================================
pause
