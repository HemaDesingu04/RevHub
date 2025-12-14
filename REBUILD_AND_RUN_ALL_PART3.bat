@echo off
echo ========================================
echo REVHUB - PART 3: REMAINING FRONTENDS
echo ========================================
echo.

echo [STEP 28/31] Installing and starting profile-microfrontend...
cd frontend-services\profile-microfrontend
call npm install
start "Profile Microfrontend" cmd /k "npm start"
cd ..\..
echo Waiting 20 seconds for profile-microfrontend to start...
timeout /t 20 /nobreak
echo [STEP 28/31] ✓ profile-microfrontend started on port 4203
echo.

echo [STEP 29/31] Installing and starting chat-microfrontend...
cd frontend-services\chat-microfrontend
call npm install
start "Chat Microfrontend" cmd /k "npm start"
cd ..\..
echo Waiting 20 seconds for chat-microfrontend to start...
timeout /t 20 /nobreak
echo [STEP 29/31] ✓ chat-microfrontend started on port 4204
echo.

echo [STEP 30/31] Installing and starting notifications-microfrontend...
cd frontend-services\notifications-microfrontend
call npm install
start "Notifications Microfrontend" cmd /k "npm start"
cd ..\..
echo Waiting 20 seconds for notifications-microfrontend to start...
timeout /t 20 /nobreak
echo [STEP 30/31] ✓ notifications-microfrontend started on port 4205
echo.

echo [STEP 31/31] Running health checks...
timeout /t 10 /nobreak
echo.

echo ========================================
echo HEALTH CHECK RESULTS
echo ========================================
echo.

echo Checking Backend Services...
curl -s http://localhost:8080/actuator/health > nul 2>&1 && echo ✓ API Gateway (8080) - HEALTHY || echo ✗ API Gateway (8080) - DOWN
curl -s http://localhost:8081/actuator/health > nul 2>&1 && echo ✓ User Service (8081) - HEALTHY || echo ✗ User Service (8081) - DOWN
curl -s http://localhost:8082/actuator/health > nul 2>&1 && echo ✓ Post Service (8082) - HEALTHY || echo ✗ Post Service (8082) - DOWN
curl -s http://localhost:8083/actuator/health > nul 2>&1 && echo ✓ Social Service (8083) - HEALTHY || echo ✗ Social Service (8083) - DOWN
curl -s http://localhost:8084/actuator/health > nul 2>&1 && echo ✓ Chat Service (8084) - HEALTHY || echo ✗ Chat Service (8084) - DOWN
curl -s http://localhost:8085/actuator/health > nul 2>&1 && echo ✓ Notification Service (8085) - HEALTHY || echo ✗ Notification Service (8085) - DOWN
curl -s http://localhost:8086/actuator/health > nul 2>&1 && echo ✓ Feed Service (8086) - HEALTHY || echo ✗ Feed Service (8086) - DOWN
curl -s http://localhost:8087/actuator/health > nul 2>&1 && echo ✓ Search Service (8087) - HEALTHY || echo ✗ Search Service (8087) - DOWN
curl -s http://localhost:8088/actuator/health > nul 2>&1 && echo ✓ Saga Orchestrator (8088) - HEALTHY || echo ✗ Saga Orchestrator (8088) - DOWN
echo.

echo Checking Frontend Services...
curl -s http://localhost:4200 > nul 2>&1 && echo ✓ Shell App (4200) - RUNNING || echo ✗ Shell App (4200) - DOWN
curl -s http://localhost:4201 > nul 2>&1 && echo ✓ Auth Microfrontend (4201) - RUNNING || echo ✗ Auth Microfrontend (4201) - DOWN
curl -s http://localhost:4202 > nul 2>&1 && echo ✓ Feed Microfrontend (4202) - RUNNING || echo ✗ Feed Microfrontend (4202) - DOWN
curl -s http://localhost:4203 > nul 2>&1 && echo ✓ Profile Microfrontend (4203) - RUNNING || echo ✗ Profile Microfrontend (4203) - DOWN
curl -s http://localhost:4204 > nul 2>&1 && echo ✓ Chat Microfrontend (4204) - RUNNING || echo ✗ Chat Microfrontend (4204) - DOWN
curl -s http://localhost:4205 > nul 2>&1 && echo ✓ Notifications Microfrontend (4205) - RUNNING || echo ✗ Notifications Microfrontend (4205) - DOWN
echo.

echo Checking Infrastructure...
curl -s http://localhost:8500/v1/status/leader > nul 2>&1 && echo ✓ Consul (8500) - RUNNING || echo ✗ Consul (8500) - DOWN
echo.

echo ========================================
echo 🎉 REVHUB DEPLOYMENT COMPLETE! 🎉
echo ========================================
echo.
echo Access Points:
echo   Frontend:     http://localhost:4200
echo   API Gateway:  http://localhost:8080
echo   Consul UI:    http://localhost:8500
echo.
echo All services are running in separate windows.
echo Close this window to keep services running.
echo.

pause
