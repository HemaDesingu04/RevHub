@echo off
echo ========================================
echo Starting RevHub - Localhost Development
echo ========================================

echo [1/4] Building shared modules...
cd scripts
call build-shared-modules.bat
cd ..

echo [2/4] Starting infrastructure...
cd scripts
call start-infrastructure.bat
cd ..

echo [3/4] Setting up databases...
cd scripts
call setup-databases.bat
cd ..

echo [4/4] Starting backend services...
cd scripts
call start-backend-services-localhost.bat
cd ..

echo ========================================
echo RevHub is starting up!
echo Frontend: http://localhost:4200
echo API Gateway: http://localhost:8080
echo Consul UI: http://localhost:8500
echo ========================================
pause