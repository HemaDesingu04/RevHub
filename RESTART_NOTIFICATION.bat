@echo off
echo Stopping Notification Service...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8085') do taskkill /F /PID %%a 2>nul
timeout /t 3 /nobreak
echo Starting Notification Service...
start "Notification Service" cmd /k "cd backend-services\notification-service && mvn spring-boot:run"
echo Done! Wait 20 seconds for service to start.
timeout /t 20 /nobreak
