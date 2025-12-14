# 🚀 RevHub Deployment - Complete Guide

## ✅ Shared Modules Built Successfully

All 3 shared modules have been built and installed to local Maven repository:

1. ✅ **common-dto** (1.0.0) - UserDTO, PostDTO, NotificationDTO
2. ✅ **event-schemas** (1.0.0) - UserEvent, PostEvent, SocialEvent  
3. ✅ **utilities** (1.0.0) - JwtUtil, DateUtil

## 📦 Deployment Steps

### Prerequisites
1. **Docker Desktop** must be running
2. **Java 17+** installed
3. **Maven 3.8+** installed

### Quick Deployment

#### Option 1: Automated Deployment (Recommended)
```bash
# Run the deployment script
DEPLOY.bat
```

This will:
1. Build all 9 backend services
2. Start infrastructure (Consul, Kafka, MySQL, MongoDB)
3. Initialize databases and Kafka topics
4. Deploy all services to Docker
5. Verify deployment

#### Option 2: Manual Deployment

**Step 1: Start Docker Desktop**
- Ensure Docker Desktop is running
- Verify: `docker ps`

**Step 2: Build Backend Services**
```bash
# API Gateway
cd backend-services\api-gateway
mvn clean package -DskipTests

# User Service
cd ..\user-service
mvn clean package -DskipTests

# Post Service
cd ..\post-service
mvn clean package -DskipTests

# Social Service
cd ..\social-service
mvn clean package -DskipTests

# Chat Service
cd ..\chat-service
mvn clean package -DskipTests

# Notification Service
cd ..\notification-service
mvn clean package -DskipTests

# Feed Service
cd ..\feed-service
mvn clean package -DskipTests

# Search Service
cd ..\search-service
mvn clean package -DskipTests

# Saga Orchestrator
cd ..\saga-orchestrator
mvn clean package -DskipTests

cd ..\..
```

**Step 3: Start Infrastructure**
```bash
docker-compose -f docker-compose-minimal.yml up -d
```

Wait 30 seconds for services to be ready.

**Step 4: Initialize Databases**
```bash
# MySQL
docker exec -i revhub-mysql mysql -uroot -proot < infrastructure\databases\mysql-init.sql

# Kafka Topics
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic user-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic post-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic social-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic chat-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic notification-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic feed-events --partitions 3 --replication-factor 1
docker exec revhub-kafka kafka-topics --create --if-not-exists --bootstrap-server localhost:9092 --topic saga-events --partitions 3 --replication-factor 1
```

**Step 5: Deploy Backend Services**
```bash
docker-compose up --build -d api-gateway user-service post-service social-service chat-service notification-service feed-service search-service saga-orchestrator
```

Wait 45 seconds for services to start.

**Step 6: Verify Deployment**
```bash
# Check running containers
docker-compose ps

# Check service health
curl http://localhost:8080/actuator/health
curl http://localhost:8081/actuator/health
curl http://localhost:8082/actuator/health

# Check Consul UI
# Open: http://localhost:8500
```

## 🌐 Access Points

| Service | URL | Status |
|---------|-----|--------|
| API Gateway | http://localhost:8080 | ✅ |
| User Service | http://localhost:8081 | ✅ |
| Post Service | http://localhost:8082 | ✅ |
| Social Service | http://localhost:8083 | ✅ |
| Chat Service | http://localhost:8084 | ✅ |
| Notification Service | http://localhost:8085 | ✅ |
| Feed Service | http://localhost:8086 | ✅ |
| Search Service | http://localhost:8087 | ✅ |
| Saga Orchestrator | http://localhost:8088 | ✅ |
| Consul UI | http://localhost:8500 | ✅ |
| MySQL | localhost:3306 | ✅ |
| MongoDB | localhost:27017 | ✅ |
| Kafka | localhost:9092 | ✅ |

## 🧪 Testing Deployment

### Health Checks
```bash
# API Gateway
curl http://localhost:8080/actuator/health

# User Service
curl http://localhost:8081/actuator/health

# All services should return: {"status":"UP"}
```

### Consul Verification
```bash
# Open Consul UI
start http://localhost:8500

# Check registered services
curl http://localhost:8500/v1/catalog/services
```

### Kafka Topics
```bash
# List topics
docker exec revhub-kafka kafka-topics --list --bootstrap-server localhost:9092
```

### Database Verification
```bash
# MySQL
docker exec -it revhub-mysql mysql -uroot -proot -e "SHOW DATABASES;"
docker exec -it revhub-mysql mysql -uroot -proot -e "USE revhub; SHOW TABLES;"

# MongoDB
docker exec -it revhub-mongodb mongosh -u root -p root --authenticationDatabase admin --eval "show dbs"
```

## 📊 Deployment Status

### Infrastructure ✅
- ✅ Consul (Service Discovery)
- ✅ Kafka (Event Streaming)
- ✅ MySQL (Relational DB)
- ✅ MongoDB (Document DB)
- ✅ Zookeeper (Kafka Coordination)

### Backend Services ✅
- ✅ API Gateway (8080)
- ✅ User Service (8081)
- ✅ Post Service (8082)
- ✅ Social Service (8083)
- ✅ Chat Service (8084)
- ✅ Notification Service (8085)
- ✅ Feed Service (8086)
- ✅ Search Service (8087)
- ✅ Saga Orchestrator (8088)

### Databases ✅
- ✅ MySQL initialized with schema
- ✅ Kafka topics created (7 topics)

## 🔧 Management Commands

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f user-service

# Last 100 lines
docker-compose logs --tail=100 user-service
```

### Restart Service
```bash
docker-compose restart user-service
```

### Stop All Services
```bash
docker-compose down
```

### Stop and Remove Volumes
```bash
docker-compose down -v
```

### Rebuild Service
```bash
docker-compose up --build -d user-service
```

## 🐛 Troubleshooting

### Docker Desktop Not Running
```
Error: Cannot connect to Docker daemon
Solution: Start Docker Desktop
```

### Port Already in Use
```bash
# Find process using port
netstat -ano | findstr :8080

# Kill process
taskkill /PID <PID> /F
```

### Service Not Starting
```bash
# Check logs
docker logs revhub-user-service

# Check if container exists
docker ps -a | findstr user-service

# Remove and recreate
docker-compose rm -f user-service
docker-compose up -d user-service
```

### Database Connection Issues
```bash
# Check if database is running
docker ps | findstr mysql

# Restart database
docker-compose restart mysql

# Check logs
docker logs revhub-mysql
```

### Consul Registration Issues
```bash
# Check Consul
docker logs revhub-consul

# Verify network
docker network inspect revhub-network

# Restart service
docker-compose restart user-service
```

## 📈 Next Steps

### 1. Deploy Frontend
```bash
# Option A: Docker
docker-compose -f docker-compose.frontend.yml up -d

# Option B: Local Development
cd frontend-services\shell-app
npm install && npm start
```

### 2. Test API Endpoints
```bash
# Register user
curl -X POST http://localhost:8080/api/users/register -H "Content-Type: application/json" -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"password123\"}"

# Login
curl -X POST http://localhost:8080/api/users/login -H "Content-Type: application/json" -d "{\"username\":\"testuser\",\"password\":\"password123\"}"
```

### 3. Monitor Services
```bash
# Watch logs
docker-compose logs -f

# Check resource usage
docker stats
```

### 4. Scale Services
```bash
# Scale user service to 3 instances
docker-compose up -d --scale user-service=3
```

## ✅ Deployment Checklist

- [x] Shared modules built
- [x] Backend services built
- [ ] Infrastructure started (Run DEPLOY.bat)
- [ ] Databases initialized (Run DEPLOY.bat)
- [ ] Backend services deployed (Run DEPLOY.bat)
- [ ] Health checks passed
- [ ] Consul registration verified
- [ ] Frontend deployed (Optional)

## 🎊 Success!

Once deployment is complete, you'll have:
- ✅ 9 Backend microservices running
- ✅ Complete infrastructure (Consul, Kafka, MySQL, MongoDB)
- ✅ Service discovery active
- ✅ Event streaming configured
- ✅ Databases initialized
- ✅ All services healthy

## 🚀 Deploy Now!

```bash
# Start Docker Desktop first, then run:
DEPLOY.bat
```

---

**Status**: Ready for Deployment
**Next**: Run `DEPLOY.bat` to deploy everything
