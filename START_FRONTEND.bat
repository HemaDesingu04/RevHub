@echo off
cd frontend-services\shell-app
start "Shell App" cmd /k "npm start"
timeout /t 5 /nobreak >nul

cd ..\feed-microfrontend
start "Feed MFE" cmd /k "npm start"
timeout /t 3 /nobreak >nul

cd ..\auth-microfrontend
start "Auth MFE" cmd /k "npm start"
timeout /t 3 /nobreak >nul

cd ..\profile-microfrontend
start "Profile MFE" cmd /k "npm start"
timeout /t 3 /nobreak >nul

cd ..\chat-microfrontend
start "Chat MFE" cmd /k "npm start"
timeout /t 3 /nobreak >nul

cd ..\notifications-microfrontend
start "Notifications MFE" cmd /k "npm start"

echo All frontends starting...
