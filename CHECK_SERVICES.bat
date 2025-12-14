@echo off
echo ========================================
echo  RevHub Services Health Check
echo ========================================
echo.

echo Checking Docker Containers...
docker ps --format "table {{.Names}}\t{{.Status}}"
echo.

echo ========================================
echo Infrastructure Services
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
docker exec revhub-mysql mysqladmin ping -h localhost -u root -proot
echo.

echo [MongoDB]
docker exec revhub-mongo mongosh --eval "db.adminCommand('ping')" --quiet
echo.

echo ========================================
echo Backend Services Health
echo ========================================
echo.

echo [API Gateway - 8080]
curl -s http://localhost:8080/actuator/health
echo.
echo.

echo [User Service - 8081]
curl -s http://localhost:8081/actuator/health
echo.
echo.

echo [Post Service - 8082]
curl -s http://localhost:8082/actuator/health
echo.
echo.

echo [Social Service - 8083]
curl -s http://localhost:8083/actuator/health
echo.
echo.

echo [Chat Service - 8084]
curl -s http://localhost:8084/actuator/health
echo.
echo.

echo [Notification Service - 8085]
curl -s http://localhost:8085/actuator/health
echo.
echo.

echo [Feed Service - 8086]
curl -s http://localhost:8086/actuator/health
echo.
echo.

echo [Search Service - 8087]
curl -s http://localhost:8087/actuator/health
echo.
echo.

echo [Saga Orchestrator - 8088]
curl -s http://localhost:8088/actuator/health
echo.
echo.

echo ========================================
echo Consul Service Registry
echo ========================================
curl -s http://localhost:8500/v1/catalog/services | jq .
echo.

echo ========================================
echo Health Check Complete!
echo ========================================
pause
