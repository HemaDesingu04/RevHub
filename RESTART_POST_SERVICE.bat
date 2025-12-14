@echo off
echo ========================================
echo Restarting Post Service
echo ========================================

echo.
echo Step 1: Finding and stopping post-service...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8082') do (
    echo Killing process on port 8082 (PID: %%a)
    taskkill /F /PID %%a 2>nul
)

echo.
echo Step 2: Waiting for port to be released...
timeout /t 3 /nobreak >nul

echo.
echo Step 3: Starting post-service...
cd backend-services\post-service
start "Post Service" cmd /k "mvn spring-boot:run"

echo.
echo ========================================
echo Post Service is starting...
echo Check the new window for logs
echo ========================================
pause
