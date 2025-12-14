@echo off
color 0A
echo.
echo ========================================
echo RevHub Microservices Deployment
echo ========================================
echo.

REM Check if Docker is running
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo ERROR: Docker Desktop is not running!
    echo.
    echo Please start Docker Desktop and try again.
    echo.
    pause
    exit /b 1
)

echo [1/5] Shared modules already built ✓
echo.

echo [2/5] Building Backend Services...
echo ========================================

cd backend-services\api-gateway
echo Building API Gateway...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\user-service
echo Building User Service...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\post-service
echo Building Post Service...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\social-service
echo Building Social Service...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\chat-service
echo Building Chat Service...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\notification-service
echo Building Notification Service...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\feed-service
echo Building Feed Service...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\search-service
echo Building Search Service...
call mvn clean package -DskipTests
cd ..\..

cd backend-services\saga-orchestrator
echo Building Saga Orchestrator...
call mvn clean package -DskipTests
cd ..\..

echo.
echo [3/5] Starting Infrastructure...
echo ========================================
docker-compose -f docker-compose-minimal.yml up -d

echo.
echo Waiting for infrastructure to be ready (30 seconds)...
timeout /t 30 /nobreak

echo.
echo [4/5] Initializing Databases...
echo ========================================
docker exec -i revhub-mysql mysql -uroot -proot < infrastructure\databases\mysql-init.sql
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic user-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic post-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic social-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic chat-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic notification-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic feed-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic saga-events --partitions 3 --replication-factor 1

echo.
echo [5/5] Deploying Backend Services...
echo ========================================
docker-compose up --build -d api-gateway user-service post-service social-service chat-service notification-service feed-service search-service saga-orchestrator

echo.
echo Waiting for services to start (45 seconds)...
timeout /t 45 /nobreak

echo.
echo ========================================
echo Deployment Complete!
echo ========================================
echo.
echo Services Status:
docker-compose ps
echo.
echo Access Points:
echo - API Gateway: http://localhost:8080
echo - Consul UI: http://localhost:8500
echo.
echo Check health:
echo curl http://localhost:8080/actuator/health
echo.
pause
