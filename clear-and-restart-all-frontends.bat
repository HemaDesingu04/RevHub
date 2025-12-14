@echo off
echo ========================================
echo Clearing and Restarting All Frontends
echo ========================================
echo.

echo Stopping all frontend services...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4200') do taskkill /F /PID %%a 2>nul
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4201') do taskkill /F /PID %%a 2>nul
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4202') do taskkill /F /PID %%a 2>nul
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4203') do taskkill /F /PID %%a 2>nul
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4204') do taskkill /F /PID %%a 2>nul
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4205') do taskkill /F /PID %%a 2>nul

echo.
echo Waiting 5 seconds...
timeout /t 5 /nobreak >nul

echo.
echo Starting Shell App (4200)...
cd frontend-services\shell-app
start "Shell App - Port 4200" cmd /k "npm start"
cd ..\..

timeout /t 3 /nobreak >nul

echo Starting Auth Microfrontend (4201)...
cd frontend-services\auth-microfrontend
start "Auth MF - Port 4201" cmd /k "npm start"
cd ..\..

timeout /t 2 /nobreak >nul

echo Starting Feed Microfrontend (4202)...
cd frontend-services\feed-microfrontend
start "Feed MF - Port 4202" cmd /k "npm start"
cd ..\..

timeout /t 2 /nobreak >nul

echo Starting Profile Microfrontend (4203)...
cd frontend-services\profile-microfrontend
start "Profile MF - Port 4203" cmd /k "npm start"
cd ..\..

timeout /t 2 /nobreak >nul

echo Starting Chat Microfrontend (4204)...
cd frontend-services\chat-microfrontend
start "Chat MF - Port 4204" cmd /k "npm start"
cd ..\..

timeout /t 2 /nobreak >nul

echo Starting Notifications Microfrontend (4205)...
cd frontend-services\notifications-microfrontend
start "Notifications MF - Port 4205" cmd /k "npm start"
cd ..\..

echo.
echo ========================================
echo All frontends are starting!
echo ========================================
echo.
echo Wait 60 seconds for all services to start, then:
echo 1. Open http://localhost:4200
echo 2. Clear browser cache (Ctrl+Shift+Delete)
echo 3. Hard refresh (Ctrl+F5)
echo 4. Login and check profile
echo.
pause
