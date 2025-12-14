@echo off
echo Building and Deploying All Services...
echo.

echo Building User Service...
cd backend-services\user-service
call mvn clean package -DskipTests -q
cd ..\..

echo Building Post Service...
cd backend-services\post-service
call mvn clean package -DskipTests -q
cd ..\..

echo Building Social Service...
cd backend-services\social-service
call mvn clean package -DskipTests -q
cd ..\..

echo Building Chat Service...
cd backend-services\chat-service
call mvn clean package -DskipTests -q
cd ..\..

echo Building Notification Service...
cd backend-services\notification-service
call mvn clean package -DskipTests -q
cd ..\..

echo Building Feed Service...
cd backend-services\feed-service
call mvn clean package -DskipTests -q
cd ..\..

echo Building Search Service...
cd backend-services\search-service
call mvn clean package -DskipTests -q
cd ..\..

echo Building Saga Orchestrator...
cd backend-services\saga-orchestrator
call mvn clean package -DskipTests -q
cd ..\..

echo.
echo All services built! Deploying to Docker...
docker-compose up --build -d api-gateway user-service post-service social-service chat-service notification-service feed-service search-service saga-orchestrator

echo.
echo Deployment complete!
docker-compose ps
