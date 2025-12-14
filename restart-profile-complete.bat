@echo off
echo ========================================
echo Restarting Profile Microfrontend
echo ========================================
echo.

echo Step 1: Stopping existing profile microfrontend...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4203') do (
    echo Killing process %%a
    taskkill /F /PID %%a 2>nul
)

echo.
echo Step 2: Waiting 3 seconds...
timeout /t 3 /nobreak >nul

echo.
echo Step 3: Rebuilding profile microfrontend...
cd frontend-services\profile-microfrontend
call npm run build
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo Step 4: Starting profile microfrontend...
start "Profile Microfrontend - Port 4203" cmd /k "npm start"

echo.
echo ========================================
echo Profile Microfrontend restarted!
echo ========================================
echo.
echo Access at: http://localhost:4203
echo.
echo IMPORTANT: 
echo 1. Wait 30 seconds for the server to start
echo 2. Clear browser cache (Ctrl+Shift+Delete)
echo 3. Hard refresh the page (Ctrl+F5)
echo 4. Check browser console for "Followers data" and "Following data" logs
echo.
pause
