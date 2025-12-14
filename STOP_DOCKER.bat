@echo off
echo ========================================
echo   Stopping RevHub Docker Services
echo ========================================
echo.

docker-compose down

echo.
echo All services stopped successfully!
echo.
pause
