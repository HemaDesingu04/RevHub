@echo off
echo Restarting Post Service...

REM Kill existing post-service process
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8082') do (
    taskkill /F /PID %%a 2>nul
)

timeout /t 2 /nobreak >nul

REM Start post-service
cd backend-services\post-service
start "Post Service" cmd /k "mvn spring-boot:run"

echo Post Service restarted!
echo Access at: http://localhost:8082
pause
