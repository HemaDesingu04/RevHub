@echo off
echo 🛑 Stopping Jenkins...
cd docker
docker-compose down
echo ✅ Jenkins stopped.
pause
