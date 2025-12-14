@echo off
echo Starting Backend Services...
echo ========================================

docker-compose up -d api-gateway user-service post-service social-service chat-service notification-service feed-service search-service saga-orchestrator

echo.
echo Waiting for services to start...
timeout /t 60 /nobreak

echo.
echo Backend services started!
echo - API Gateway: http://localhost:8080
echo - User Service: http://localhost:8081
echo - Post Service: http://localhost:8082
echo - Social Service: http://localhost:8083
echo - Chat Service: http://localhost:8084
echo - Notification Service: http://localhost:8085
echo - Feed Service: http://localhost:8086
echo - Search Service: http://localhost:8087
echo - Saga Orchestrator: http://localhost:8088
echo.
echo Open http://localhost:4200 to access the application
echo.
pause
