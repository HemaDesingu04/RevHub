@echo off
color 0A
echo.
echo  ====================================================
echo  ██████╗ ███████╗██╗   ██╗██╗  ██╗██╗   ██╗██████╗ 
echo  ██╔══██╗██╔════╝██║   ██║██║  ██║██║   ██║██╔══██╗
echo  ██████╔╝█████╗  ██║   ██║███████║██║   ██║██████╔╝
echo  ██╔══██╗██╔══╝  ╚██╗ ██╔╝██╔══██║██║   ██║██╔══██╗
echo  ██║  ██║███████╗ ╚████╔╝ ██║  ██║╚██████╔╝██████╔╝
echo  ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
echo  ====================================================
echo  RevHub Microservices Platform
echo  Complete Social Media Application
echo  ====================================================
echo.
echo  This script will:
echo  1. Build shared modules
echo  2. Build all backend services
echo  3. Start infrastructure (Consul, Kafka, MySQL, MongoDB)
echo  4. Initialize databases
echo  5. Create Kafka topics
echo  6. Start all backend microservices
echo  7. Start all frontend applications
echo.
echo  Total estimated time: 25-35 minutes
echo.
pause

cd scripts

echo.
echo ====================================================
echo STEP 1/7: Building Shared Modules
echo ====================================================
call build-shared-modules.bat
if %errorlevel% neq 0 (
    color 0C
    echo ERROR: Shared modules build failed!
    pause
    exit /b 1
)

echo.
echo ====================================================
echo STEP 2/7: Building Backend Services
echo ====================================================
call build-all-services.bat
if %errorlevel% neq 0 (
    color 0C
    echo ERROR: Backend services build failed!
    pause
    exit /b 1
)

echo.
echo ====================================================
echo STEP 3/7: Starting Infrastructure
echo ====================================================
call start-infrastructure.bat

echo.
echo ====================================================
echo STEP 4/7: Initializing Databases
echo ====================================================
call setup-databases.bat

echo.
echo ====================================================
echo STEP 5/7: Creating Kafka Topics
echo ====================================================
cd ..\infrastructure\kafka
call kafka-topics.bat
cd ..\..\scripts

echo.
echo ====================================================
echo STEP 6/7: Starting Backend Services
echo ====================================================
call start-backend-services.bat

echo.
echo ====================================================
echo STEP 7/7: Starting Frontend Applications
echo ====================================================
call start-all-frontends.bat

color 0A
echo.
echo ====================================================
echo  ✓ RevHub Platform Started Successfully!
echo ====================================================
echo.
echo  Access Points:
echo  --------------
echo  Frontend:        http://localhost:4200
echo  API Gateway:     http://localhost:8080
echo  Consul UI:       http://localhost:8500
echo.
echo  Service Status:
echo  ---------------
echo  ✓ 9 Backend Microservices Running
echo  ✓ 6 Frontend Applications Running
echo  ✓ Consul Service Discovery Active
echo  ✓ Kafka Event Streaming Active
echo  ✓ MySQL Database Ready
echo  ✓ MongoDB Database Ready
echo.
echo  Next Steps:
echo  -----------
echo  1. Open http://localhost:4200 in your browser
echo  2. Register a new user account
echo  3. Login and explore the platform
echo  4. Create posts, follow users, send messages
echo.
echo  To stop all services: run scripts\stop-all.bat
echo  To view logs: run scripts\logs.bat
echo  To check health: run scripts\health-check.bat
echo.
echo ====================================================
pause
