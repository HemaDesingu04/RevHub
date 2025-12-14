@echo off
echo Stopping notification-service...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8085') do taskkill /F /PID %%a 2>nul
timeout /t 2 /nobreak
echo Starting notification-service...
start "Notification Service" cmd /k "cd backend-services\notification-service && mvn spring-boot:run"
echo Done! Refresh browser in 20 seconds.
timeout /t 20 /nobreak
