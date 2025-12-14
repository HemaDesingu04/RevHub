# 🐳 Docker Quick Reference

## Start/Stop Commands

```bash
# Start everything
START_DOCKER.bat

# Stop everything
STOP_DOCKER.bat

# View logs
DOCKER_LOGS.bat
```

## Docker Compose Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View status
docker-compose ps

# View logs (all)
docker-compose logs -f

# View logs (specific service)
docker-compose logs -f user-service

# Restart service
docker-compose restart user-service

# Rebuild and restart
docker-compose up -d --build user-service

# Stop and remove volumes
docker-compose down -v
```

## Service Management

```bash
# List running containers
docker ps

# Stop specific container
docker stop revhub-user-service

# Start specific container
docker start revhub-user-service

# Remove container
docker rm revhub-user-service

# Execute command in container
docker exec -it revhub-user-service sh
```

## Debugging

```bash
# Check service logs
docker-compose logs -f <service-name>

# Check container status
docker ps -a

# Inspect container
docker inspect revhub-user-service

# Check network
docker network inspect revhub-microservices_revhub-network

# Check volumes
docker volume ls
```

## Database Access

```bash
# MySQL
docker exec -it revhub-mysql mysql -uroot -proot revhub

# MongoDB
docker exec -it revhub-mongodb mongosh -u root -p root --authenticationDatabase admin
```

## Rebuild After Code Changes

```bash
# 1. Rebuild JAR
cd backend-services\user-service
mvn clean package -DskipTests

# 2. Rebuild Docker image and restart
cd ..\..
docker-compose up -d --build user-service
```

## Clean Everything

```bash
# Stop and remove containers
docker-compose down -v

# Remove images
docker rmi $(docker images | grep revhub | awk '{print $3}')

# Start fresh
START_DOCKER.bat
```

## Health Checks

```bash
curl http://localhost:8080/actuator/health  # API Gateway
curl http://localhost:8081/actuator/health  # User Service
curl http://localhost:8082/actuator/health  # Post Service
curl http://localhost:8083/actuator/health  # Social Service
curl http://localhost:8084/actuator/health  # Chat Service
curl http://localhost:8085/actuator/health  # Notification Service
curl http://localhost:8086/actuator/health  # Feed Service
curl http://localhost:8087/actuator/health  # Search Service
curl http://localhost:8088/actuator/health  # Saga Orchestrator
```

## URLs

- Frontend: http://localhost:4200
- API Gateway: http://localhost:8080
- Consul UI: http://localhost:8500
- Services: http://localhost:8081-8088
