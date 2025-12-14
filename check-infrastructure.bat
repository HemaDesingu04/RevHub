@echo off
echo Checking Infrastructure Services...
echo ========================================
docker ps --filter "name=revhub-consul" --filter "name=revhub-zookeeper" --filter "name=revhub-kafka" --filter "name=revhub-mysql" --filter "name=revhub-mongo" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.
pause
