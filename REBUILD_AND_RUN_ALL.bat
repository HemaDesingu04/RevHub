@echo off
echo ========================================
echo REVHUB - REBUILD AND RUN ALL MODULES
echo ========================================
echo.

REM Set colors for output
color 0A

echo [STEP 1/15] Cleaning previous builds...
call scripts\clean-all.bat
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Clean failed!
    pause
    exit /b 1
)
echo [STEP 1/15] ✓ Clean complete
echo.

echo [STEP 2/15] Building Shared Module: common-dto...
cd shared\common-dto
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: common-dto build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 2/15] ✓ common-dto built successfully
echo.

echo [STEP 3/15] Building Shared Module: event-schemas...
cd shared\event-schemas
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: event-schemas build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 3/15] ✓ event-schemas built successfully
echo.

echo [STEP 4/15] Building Shared Module: utilities...
cd shared\utilities
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: utilities build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 4/15] ✓ utilities built successfully
echo.

echo [STEP 5/15] Starting Infrastructure (Consul, Kafka, Databases)...
start "Infrastructure" cmd /k "cd infrastructure && docker-compose up"
echo Waiting 30 seconds for infrastructure to start...
timeout /t 30 /nobreak
echo [STEP 5/15] ✓ Infrastructure started
echo.

echo [STEP 6/15] Building Backend Service: user-service...
cd backend-services\user-service
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: user-service build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 6/15] ✓ user-service built successfully
echo.

echo [STEP 7/15] Starting user-service...
start "User Service" cmd /k "cd backend-services\user-service && mvn spring-boot:run"
echo Waiting 20 seconds for user-service to start...
timeout /t 20 /nobreak
echo [STEP 7/15] ✓ user-service started on port 8081
echo.

echo [STEP 8/15] Building Backend Service: post-service...
cd backend-services\post-service
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: post-service build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 8/15] ✓ post-service built successfully
echo.

echo [STEP 9/15] Starting post-service...
start "Post Service" cmd /k "cd backend-services\post-service && mvn spring-boot:run"
echo Waiting 20 seconds for post-service to start...
timeout /t 20 /nobreak
echo [STEP 9/15] ✓ post-service started on port 8082
echo.

echo [STEP 10/15] Building Backend Service: social-service...
cd backend-services\social-service
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: social-service build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 10/15] ✓ social-service built successfully
echo.

echo [STEP 11/15] Starting social-service...
start "Social Service" cmd /k "cd backend-services\social-service && mvn spring-boot:run"
echo Waiting 20 seconds for social-service to start...
timeout /t 20 /nobreak
echo [STEP 11/15] ✓ social-service started on port 8083
echo.

echo [STEP 12/15] Building Backend Service: chat-service...
cd backend-services\chat-service
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: chat-service build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 12/15] ✓ chat-service built successfully
echo.

echo [STEP 13/15] Starting chat-service...
start "Chat Service" cmd /k "cd backend-services\chat-service && mvn spring-boot:run"
echo Waiting 20 seconds for chat-service to start...
timeout /t 20 /nobreak
echo [STEP 13/15] ✓ chat-service started on port 8084
echo.

echo [STEP 14/15] Building Backend Service: notification-service...
cd backend-services\notification-service
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: notification-service build failed!
    cd ..\..
    pause
    exit /b 1
)
cd ..\..
echo [STEP 14/15] ✓ notification-service built successfully
echo.

echo [STEP 15/15] Starting notification-service...
start "Notification Service" cmd /k "cd backend-services\notification-service && mvn spring-boot:run"
echo Waiting 20 seconds for notification-service to start...
timeout /t 20 /nobreak
echo [STEP 15/15] ✓ notification-service started on port 8085
echo.

echo ========================================
echo CONTINUING WITH REMAINING SERVICES...
echo ========================================
echo.

REM Continue with remaining services
call REBUILD_AND_RUN_ALL_PART2.bat

pause
