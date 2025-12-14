@echo off
echo ========================================
echo RESTARTING CHAT SERVICE
echo ========================================
echo.

echo Stopping any running chat-service instances...
taskkill /FI "WINDOWTITLE eq Chat Service*" /F 2>nul

echo Waiting 5 seconds...
timeout /t 5 /nobreak

echo Starting chat-service...
start "Chat Service" cmd /k "cd backend-services\chat-service && mvn spring-boot:run"

echo.
echo ========================================
echo Chat Service is restarting...
echo Wait 20-30 seconds for it to fully start
echo ========================================
pause
