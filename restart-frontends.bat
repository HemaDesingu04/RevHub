@echo off
echo Restarting all frontend services with proxy configurations...

echo.
echo Stopping any existing frontend processes...
taskkill /f /im node.exe 2>nul

echo.
echo Starting frontend services...

start "Shell App" cmd /k "cd frontend-services\shell-app && npm start"
timeout /t 5 /nobreak >nul

start "Auth Microfrontend" cmd /k "cd frontend-services\auth-microfrontend && npm start"
timeout /t 3 /nobreak >nul

start "Feed Microfrontend" cmd /k "cd frontend-services\feed-microfrontend && npm start"
timeout /t 3 /nobreak >nul

start "Profile Microfrontend" cmd /k "cd frontend-services\profile-microfrontend && npm start"
timeout /t 3 /nobreak >nul

start "Chat Microfrontend" cmd /k "cd frontend-services\chat-microfrontend && npm start"
timeout /t 3 /nobreak >nul

start "Notifications Microfrontend" cmd /k "cd frontend-services\notifications-microfrontend && npm start"

echo.
echo All frontend services are starting...
echo Wait a few moments for all services to be ready.
echo.
echo Access points:
echo - Main App: http://localhost:4200
echo - Auth: http://localhost:4201
echo - Feed: http://localhost:4202
echo - Profile: http://localhost:4203
echo - Chat: http://localhost:4204
echo - Notifications: http://localhost:4205

pause