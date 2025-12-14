@echo off
echo ========================================
echo REVHUB - PART 2: REMAINING SERVICES
echo ========================================
echo.

echo [STEP 16/21] Building Backend Service: feed-service...
cd backend-services\feed-service
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: feed-service build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 16/21] ✓ feed-service built successfully
echo.

echo [STEP 17/21] Starting feed-service...
start "Feed Service" cmd /k "cd backend-services\feed-service && mvn spring-boot:run"
echo Waiting 20 seconds for feed-service to start...
timeout /t 20 /nobreak
echo [STEP 17/21] ✓ feed-service started on port 8086
echo.

echo [STEP 18/21] Building Backend Service: search-service...
cd backend-services\search-service
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: search-service build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 18/21] ✓ search-service built successfully
echo.

echo [STEP 19/21] Starting search-service...
start "Search Service" cmd /k "cd backend-services\search-service && mvn spring-boot:run"
echo Waiting 20 seconds for search-service to start...
timeout /t 20 /nobreak
echo [STEP 19/21] ✓ search-service started on port 8087
echo.

echo [STEP 20/21] Building Backend Service: saga-orchestrator...
cd backend-services\saga-orchestrator
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: saga-orchestrator build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 20/21] ✓ saga-orchestrator built successfully
echo.

echo [STEP 21/21] Starting saga-orchestrator...
start "Saga Orchestrator" cmd /k "cd backend-services\saga-orchestrator && mvn spring-boot:run"
echo Waiting 20 seconds for saga-orchestrator to start...
timeout /t 20 /nobreak
echo [STEP 21/21] ✓ saga-orchestrator started on port 8088
echo.

echo [STEP 22/27] Building Backend Service: api-gateway...
cd backend-services\api-gateway
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: api-gateway build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 22/27] ✓ api-gateway built successfully
echo.

echo [STEP 23/27] Starting api-gateway...
start "API Gateway" cmd /k "cd backend-services\api-gateway && mvn spring-boot:run"
echo Waiting 30 seconds for api-gateway to start...
timeout /t 30 /nobreak
echo [STEP 23/27] ✓ api-gateway started on port 8080
echo.

echo ========================================
echo ALL BACKEND SERVICES STARTED!
echo ========================================
echo.
echo Starting Frontend Services...
echo.

echo [STEP 24/27] Installing dependencies for shell-app...
cd frontend-services\shell-app
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: shell-app npm install failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 24/27] ✓ shell-app dependencies installed
echo.

echo [STEP 25/27] Starting shell-app...
start "Shell App" cmd /k "cd frontend-services\shell-app && npm start"
echo Waiting 30 seconds for shell-app to start...
timeout /t 30 /nobreak
echo [STEP 25/27] ✓ shell-app started on port 4200
echo.

echo [STEP 26/27] Installing and starting auth-microfrontend...
cd frontend-services\auth-microfrontend
call npm install
start "Auth Microfrontend" cmd /k "npm start"
cd ..\..
echo Waiting 20 seconds for auth-microfrontend to start...
timeout /t 20 /nobreak
echo [STEP 26/27] ✓ auth-microfrontend started on port 4201
echo.

echo [STEP 27/27] Installing and starting feed-microfrontend...
cd frontend-services\feed-microfrontend
call npm install
start "Feed Microfrontend" cmd /k "npm start"
cd ..\..
echo Waiting 20 seconds for feed-microfrontend to start...
timeout /t 20 /nobreak
echo [STEP 27/27] ✓ feed-microfrontend started on port 4202
echo.

REM Continue with remaining frontends
call REBUILD_AND_RUN_ALL_PART3.bat

pause
