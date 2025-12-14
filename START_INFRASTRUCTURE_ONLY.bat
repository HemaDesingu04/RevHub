@echo off
echo ========================================
echo   Starting Infrastructure Only
echo ========================================
echo.

echo Starting Consul, MySQL, and MongoDB...
docker-compose up -d consul mysql mongodb

echo.
echo Waiting for infrastructure to start...
timeout /t 30 /nobreak

echo.
echo Infrastructure Status:
docker-compose ps consul mysql mongodb

echo.
echo Access Points:
echo   Consul UI:  http://localhost:8500
echo   MySQL:      localhost:3306
echo   MongoDB:    localhost:27017
echo.
pause