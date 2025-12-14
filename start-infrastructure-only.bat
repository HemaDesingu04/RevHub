@echo off
echo ========================================
echo Starting RevHub Infrastructure Only
echo ========================================
echo.

cd infrastructure

echo Starting Consul...
start "Consul" cmd /k "cd consul && consul agent -dev -ui -client=0.0.0.0"
timeout /t 5 /nobreak >nul

echo Starting Kafka (with Zookeeper)...
start "Kafka" cmd /k "cd kafka && kafka-server-start.bat ..\..\config\server.properties"
timeout /t 10 /nobreak >nul

echo Starting MySQL...
start "MySQL" cmd /k "docker run --name revhub-mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=revhub -p 3306:3306 mysql:8.0"
timeout /t 10 /nobreak >nul

echo Starting MongoDB...
start "MongoDB" cmd /k "docker run --name revhub-mongodb -p 27017:27017 mongodb/mongodb-community-server:7.0-ubuntu2204"
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo Infrastructure Started Successfully!
echo ========================================
echo.
echo Services:
echo - Consul UI: http://localhost:8500
echo - Kafka: localhost:9092
echo - MySQL: localhost:3306
echo - MongoDB: localhost:27017
echo.
echo Press any key to exit...
pause >nul
