@echo off
echo Building shared modules...
cd shared\common-dto
call mvn clean install -DskipTests
cd ..\event-schemas
call mvn clean install -DskipTests
cd ..\utilities
call mvn clean install -DskipTests
cd ..\..

echo Building backend services...
for %%s in (api-gateway user-service post-service social-service chat-service notification-service feed-service search-service saga-orchestrator) do (
    echo Building %%s...
    cd backend-services\%%s
    call mvn clean package -DskipTests
    cd ..\..
)

echo Starting Docker containers...
docker-compose up -d --build

echo Done!
docker-compose ps
