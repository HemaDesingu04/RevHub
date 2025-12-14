@echo off
echo ========================================
echo AUTO RESTARTING UPDATED SERVICES
echo ========================================
echo.

echo Killing old service processes...
echo.

REM Kill Java processes running on specific ports
echo Stopping User Service (port 8081)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8081') do taskkill /F /PID %%a 2>nul

echo Stopping Notification Service (port 8085)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8085') do taskkill /F /PID %%a 2>nul

echo Stopping Post Service (port 8082)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8082') do taskkill /F /PID %%a 2>nul

echo.
echo Waiting 5 seconds for processes to stop...
timeout /t 5 /nobreak

echo.
echo ========================================
echo STARTING UPDATED SERVICES
echo ========================================
echo.

echo [1/3] Starting User Service on port 8081...
start "User Service" cmd /k "cd backend-services\user-service && mvn spring-boot:run"
timeout /t 10 /nobreak

echo [2/3] Starting Notification Service on port 8085...
start "Notification Service" cmd /k "cd backend-services\notification-service && mvn spring-boot:run"
timeout /t 10 /nobreak

echo [3/3] Starting Post Service on port 8082...
start "Post Service" cmd /k "cd backend-services\post-service && mvn spring-boot:run"

echo.
echo ========================================
echo Services are starting...
echo Please wait 30 seconds for all services to be ready
echo ========================================
timeout /t 30 /nobreak

echo.
echo ✓ Done! All services should be ready now.
echo ✓ Refresh your browser at http://localhost:4200
echo.
pause
