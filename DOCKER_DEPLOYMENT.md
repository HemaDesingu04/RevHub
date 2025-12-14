# 🐳 RevHub Docker Deployment Guide

## Overview
All backend services are now fully containerized and run in Docker containers.

## Architecture
```
Docker Network: revhub-network
├── Infrastructure (Consul, Kafka, MySQL, MongoDB)
└── Backend Services (9 microservices)
    ├── api-gateway (8080)
    ├── user-service (8081)
    ├── post-service (8082)
    ├── social-service (8083)
    ├── chat-service (8084)
    ├── notification-service (8085)
    ├── feed-service (8086)
    ├── search-service (8087)
    └── saga-orchestrator (8088)
```

## Quick Start

### 1. Start Everything in Docker
```bash
START_DOCKER.bat
```

This will:
- Build shared modules
- Build all backend services
- Create Docker images
- Start all containers
- Initialize databases

### 2. Stop All Services
```bash
STOP_DOCKER.bat
```

### 3. View Logs
```bash
DOCKER_LOGS.bat
```

## Manual Commands

### Build and Start
```bash
# Build shared modules
cd shared
mvn clean install -DskipTests

# Build all services
cd backend-services\user-service
mvn clean package -DskipTests
# Repeat for all services...

# Start containers
docker-compose up -d --build
```

### View Status
```bash
docker-compose ps
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f user-service
```

### Restart Service
```bash
docker-compose restart user-service
```

### Rebuild Service
```bash
# Rebuild JAR
cd backend-services\user-service
mvn clean package -DskipTests

# Rebuild and restart container
docker-compose up -d --build user-service
```

### Stop All
```bash
docker-compose down
```

### Remove Volumes (Clean Start)
```bash
docker-compose down -v
```

## Service Discovery

Services register with Consul using their container hostname:
- `api-gateway` → Consul registers as "api-gateway"
- `user-service` → Consul registers as "user-service"
- etc.

API Gateway routes requests using Consul service discovery:
- `/api/users/**` → `lb://user-service`
- `/api/posts/**` → `lb://post-service`
- etc.

## Environment Variables

Each service uses these environment variables:
- `CONSUL_HOST=consul` - Consul service discovery
- `DB_HOST=mysql` - MySQL database (for SQL services)
- `MONGODB_HOST=mongodb` - MongoDB database (for NoSQL services)
- `KAFKA_BOOTSTRAP_SERVERS=kafka:9092` - Kafka message broker
- `HOSTNAME=<service-name>` - Container hostname for registration

## Health Checks

Check service health:
```bash
# API Gateway
curl http://localhost:8080/actuator/health

# User Service
curl http://localhost:8081/actuator/health

# Check Consul UI
http://localhost:8500
```

## Troubleshooting

### Service Won't Start
```bash
# Check logs
docker-compose logs -f <service-name>

# Check if port is in use
netstat -ano | findstr :8081

# Restart service
docker-compose restart <service-name>
```

### Database Connection Issues
```bash
# Check MySQL
docker exec -it revhub-mysql mysql -uroot -proot -e "SHOW DATABASES;"

# Check MongoDB
docker exec -it revhub-mongodb mongosh -u root -p root --authenticationDatabase admin
```

### Rebuild Everything
```bash
# Stop and remove everything
docker-compose down -v

# Remove old images
docker rmi $(docker images | grep revhub | awk '{print $3}')

# Start fresh
START_DOCKER.bat
```

### Service Not Registering with Consul
1. Check Consul is running: `docker ps | grep consul`
2. Check service logs: `docker-compose logs -f <service-name>`
3. Verify Consul UI: http://localhost:8500

## Access Points

| Service | URL | Container |
|---------|-----|-----------|
| API Gateway | http://localhost:8080 | revhub-api-gateway |
| User Service | http://localhost:8081 | revhub-user-service |
| Post Service | http://localhost:8082 | revhub-post-service |
| Social Service | http://localhost:8083 | revhub-social-service |
| Chat Service | http://localhost:8084 | revhub-chat-service |
| Notification | http://localhost:8085 | revhub-notification-service |
| Feed Service | http://localhost:8086 | revhub-feed-service |
| Search Service | http://localhost:8087 | revhub-search-service |
| Saga Service | http://localhost:8088 | revhub-saga-orchestrator |
| Consul UI | http://localhost:8500 | revhub-consul |
| MySQL | localhost:3306 | revhub-mysql |
| MongoDB | localhost:27017 | revhub-mongodb |
| Kafka | localhost:9092 | revhub-kafka |

## Frontend

Frontend applications still run locally (not containerized):
```bash
cd frontend-services\shell-app
npm start
```

Frontend connects to backend via API Gateway at `http://localhost:8080`

## Production Considerations

For production deployment:
1. Use proper secrets management (not hardcoded passwords)
2. Add health check endpoints to docker-compose
3. Configure resource limits (CPU, memory)
4. Use Docker Swarm or Kubernetes for orchestration
5. Implement proper logging and monitoring
6. Use external volumes for data persistence
7. Configure proper network security
8. Use multi-stage Docker builds for smaller images

## Benefits of Docker Deployment

✅ Consistent environment across all machines
✅ Easy to start/stop all services
✅ Isolated network for microservices
✅ Automatic service restart on failure
✅ Easy to scale services
✅ Production-like environment
✅ No need to manage Java processes manually
✅ Clean separation of concerns
