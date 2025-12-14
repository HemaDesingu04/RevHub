@echo off
echo ========================================
echo RESTARTING UPDATED SERVICES
echo ========================================
echo.
echo Please manually close these service windows:
echo 1. User Service (port 8081)
echo 2. Notification Service (port 8085)
echo 3. Post Service (port 8082)
echo.
echo Press any key after closing them...
pause

echo.
echo Starting User Service...
start "User Service" cmd /k "cd backend-services\user-service && mvn spring-boot:run"
timeout /t 5 /nobreak

echo Starting Notification Service...
start "Notification Service" cmd /k "cd backend-services\notification-service && mvn spring-boot:run"
timeout /t 5 /nobreak

echo Starting Post Service...
start "Post Service" cmd /k "cd backend-services\post-service && mvn spring-boot:run"

echo.
echo ========================================
echo Services are starting...
echo Wait 30 seconds for all services to be ready
echo ========================================
timeout /t 30 /nobreak

echo.
echo Done! Services should be ready now.
pause
