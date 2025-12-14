@echo off
echo ========================================
echo Starting RevHub Services
echo ========================================
echo.

echo Step 1: Starting Docker Desktop...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
echo Waiting 30 seconds for Docker to start...
timeout /t 30 /nobreak

echo.
echo Step 2: Starting infrastructure...
cd infrastructure
docker-compose up -d
cd ..

echo.
echo Waiting 20 seconds for infrastructure...
timeout /t 20 /nobreak

echo.
echo Step 3: Starting backend services...
cd scripts
call start-backend-services.bat

echo.
echo ========================================
echo All services started!
echo ========================================
pause
