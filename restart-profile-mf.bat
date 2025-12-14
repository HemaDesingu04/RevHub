@echo off
echo Restarting Profile Microfrontend...
echo ===================================

REM Kill existing profile microfrontend process
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4203') do taskkill /F /PID %%a 2>nul

echo Waiting 3 seconds...
timeout /t 3 /nobreak >nul

echo Starting Profile Microfrontend on port 4203...
cd frontend-services\profile-microfrontend
start "Profile MF" cmd /k "npm start"

echo.
echo Profile Microfrontend is starting...
echo Access at: http://localhost:4203
echo.
pause
