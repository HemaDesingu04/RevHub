@echo off
echo Stopping all containers...
docker-compose down

echo Removing API Gateway container...
docker rm -f revhub-api-gateway 2>nul

echo Starting all services...
docker-compose up -d

echo Waiting for services to start...
timeout /t 30 /nobreak

echo Checking service status...
docker ps

echo.
echo Services started!
echo API Gateway: http://localhost:8080
echo Consul: http://localhost:8500
echo Frontend: http://localhost:4200
pause
