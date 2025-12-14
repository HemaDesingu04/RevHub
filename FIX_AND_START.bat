@echo off
echo ========================================
echo  RevHub Complete Fix and Restart
echo ========================================
echo.
echo This will:
echo 1. Stop all containers
echo 2. Clean Docker system
echo 3. Start infrastructure services
echo 4. Initialize Kafka topics
echo 5. Start all backend services
echo 6. Verify all connections
echo.
pause

echo.
echo [Step 1/6] Stopping all containers...
docker-compose down -v
echo.

echo [Step 2/6] Cleaning Docker system...
docker system prune -f
echo.

echo [Step 3/6] Starting infrastructure services...
docker-compose up -d consul zookeeper kafka mysql mongodb
echo Waiting 40 seconds for infrastructure to be ready...
timeout /t 40 /nobreak
echo.

echo [Step 4/6] Initializing Kafka topics...
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic user-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic post-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic social-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic chat-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic notification-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic feed-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --topic saga-events --bootstrap-server localhost:9092 --partitions 3 --replication-factor 1
echo.

echo [Step 5/6] Starting all backend services...
docker-compose up -d
echo Waiting 60 seconds for services to start...
timeout /t 60 /nobreak
echo.

echo [Step 6/6] Verifying services...
echo.
echo ========================================
echo Docker Containers Status
echo ========================================
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo ========================================
echo Infrastructure Health
echo ========================================
echo.
echo [Consul]
curl -s http://localhost:8500/v1/status/leader
echo.
echo.

echo [Kafka Topics]
docker exec revhub-kafka kafka-topics --list --bootstrap-server localhost:9092
echo.

echo [MySQL]
docker exec revhub-mysql mysqladmin ping -h localhost -u root -proot 2>nul
echo.

echo [MongoDB]
docker exec revhub-mongo mongosh --eval "db.adminCommand('ping')" --quiet 2>nul
echo.

echo ========================================
echo Backend Services Health
echo ========================================
echo.
echo Waiting 10 more seconds for services to fully initialize...
timeout /t 10 /nobreak
echo.

echo [API Gateway - 8080]
curl -s http://localhost:8080/actuator/health
echo.

echo [User Service - 8081]
curl -s http://localhost:8081/actuator/health
echo.

echo [Post Service - 8082]
curl -s http://localhost:8082/actuator/health
echo.

echo [Social Service - 8083]
curl -s http://localhost:8083/actuator/health
echo.

echo [Chat Service - 8084]
curl -s http://localhost:8084/actuator/health
echo.

echo [Notification Service - 8085]
curl -s http://localhost:8085/actuator/health
echo.

echo [Feed Service - 8086]
curl -s http://localhost:8086/actuator/health
echo.

echo [Search Service - 8087]
curl -s http://localhost:8087/actuator/health
echo.

echo [Saga Orchestrator - 8088]
curl -s http://localhost:8088/actuator/health
echo.

echo.
echo ========================================
echo  All Services Started!
echo ========================================
echo.
echo Access Points:
echo - Consul UI: http://localhost:8500
echo - API Gateway: http://localhost:8080
echo - Frontend: http://localhost:4200
echo.
echo If any service shows DOWN, wait 30 more seconds and run:
echo   CHECK_SERVICES.bat
echo.
echo To view logs of a specific service:
echo   docker logs revhub-[service-name]
echo.
pause
