@echo off
echo ========================================
echo  RevHub Docker Services - RESTART
echo ========================================
echo.

echo [1/5] Stopping all containers...
docker-compose down
echo.

echo [2/5] Removing old containers and networks...
docker-compose down -v
echo.

echo [3/5] Cleaning up Docker system...
docker system prune -f
echo.

echo [4/5] Starting infrastructure services first...
docker-compose up -d consul zookeeper kafka mysql mongodb
echo Waiting 30 seconds for infrastructure to be ready...
timeout /t 30 /nobreak
echo.

echo [5/5] Starting all backend services...
docker-compose up -d
echo.

echo ========================================
echo Waiting 60 seconds for all services to start...
timeout /t 60 /nobreak
echo.

echo ========================================
echo Checking service status...
echo ========================================
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo ========================================
echo Service Health Check
echo ========================================
echo Consul: http://localhost:8500
echo API Gateway: http://localhost:8080/actuator/health
echo User Service: http://localhost:8081/actuator/health
echo Post Service: http://localhost:8082/actuator/health
echo Social Service: http://localhost:8083/actuator/health
echo Chat Service: http://localhost:8084/actuator/health
echo Notification Service: http://localhost:8085/actuator/health
echo Feed Service: http://localhost:8086/actuator/health
echo Search Service: http://localhost:8087/actuator/health
echo Saga Orchestrator: http://localhost:8088/actuator/health
echo.

echo ========================================
echo All services restarted!
echo ========================================
pause
