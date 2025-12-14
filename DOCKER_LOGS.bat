@echo off
echo ========================================
echo   RevHub Docker Logs
echo ========================================
echo.
echo Available services:
echo   1. api-gateway
echo   2. user-service
echo   3. post-service
echo   4. social-service
echo   5. chat-service
echo   6. notification-service
echo   7. feed-service
echo   8. search-service
echo   9. saga-orchestrator
echo   10. All services
echo.

set /p choice="Enter service number (1-10): "

if "%choice%"=="1" docker-compose logs -f api-gateway
if "%choice%"=="2" docker-compose logs -f user-service
if "%choice%"=="3" docker-compose logs -f post-service
if "%choice%"=="4" docker-compose logs -f social-service
if "%choice%"=="5" docker-compose logs -f chat-service
if "%choice%"=="6" docker-compose logs -f notification-service
if "%choice%"=="7" docker-compose logs -f feed-service
if "%choice%"=="8" docker-compose logs -f search-service
if "%choice%"=="9" docker-compose logs -f saga-orchestrator
if "%choice%"=="10" docker-compose logs -f
