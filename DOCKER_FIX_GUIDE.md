# 🔧 Docker Services Fix Guide

## Problem
After Docker shutdown and restart, some services are not connecting properly to Kafka, Consul, and databases.

## Solution Applied

### 1. Updated docker-compose.yml
- ✅ Added health checks for all infrastructure services (Consul, Zookeeper, Kafka, MySQL, MongoDB)
- ✅ Fixed Kafka advertised listeners configuration
- ✅ Added proper dependency conditions (service_healthy instead of service_started)
- ✅ Added SPRING_PROFILES_ACTIVE=docker to all backend services
- ✅ Enabled Kafka auto-create topics

### 2. Service Startup Order
Infrastructure services start first with health checks:
1. Consul (with health check)
2. Zookeeper (with health check)
3. Kafka (with health check - waits for Zookeeper)
4. MySQL (with health check)
5. MongoDB (with health check)

Backend services start only after infrastructure is healthy:
- All services wait for Consul, Kafka, and their respective databases to be healthy

### 3. Connection Configurations

#### Kafka Connection
- Internal services use: `kafka:29092`
- External/localhost use: `localhost:9092`
- Fixed advertised listeners for proper routing

#### Consul Connection
- All services connect to: `consul:8500`
- Health checks enabled for service registration

#### Database Connections
- MySQL services connect to: `mysql:3306`
- MongoDB services connect to: `mongodb:27017`

## 🚀 How to Restart Services

### Option 1: Complete Restart (Recommended)
```bash
RESTART_DOCKER.bat
```
This will:
1. Stop all containers
2. Remove volumes and networks
3. Clean Docker system
4. Start infrastructure first (30s wait)
5. Start all backend services (60s wait)
6. Show service status

### Option 2: Manual Restart
```bash
# Stop everything
docker-compose down -v

# Start infrastructure first
docker-compose up -d consul zookeeper kafka mysql mongodb

# Wait 30 seconds
timeout /t 30

# Start all services
docker-compose up -d

# Wait 60 seconds
timeout /t 60
```

### Option 3: Quick Restart (if images exist)
```bash
docker-compose restart
```

## 🔍 Verify Services

### Check All Services
```bash
CHECK_SERVICES.bat
```

### Check Docker Containers
```bash
docker ps
```

### Check Specific Service Logs
```bash
docker logs revhub-user-service
docker logs revhub-kafka
docker logs revhub-consul
```

### Check Service Health
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

### Check Consul Services
```bash
# Open browser
http://localhost:8500
```

### Check Kafka Topics
```bash
INIT_KAFKA_TOPICS.bat
```

## 🐛 Troubleshooting

### Service Won't Start
```bash
# Check logs
docker logs revhub-[service-name]

# Check if port is in use
netstat -ano | findstr :[port]

# Restart specific service
docker-compose restart [service-name]
```

### Kafka Connection Issues
```bash
# Check Kafka is running
docker exec revhub-kafka kafka-broker-api-versions --bootstrap-server localhost:9092

# List topics
docker exec revhub-kafka kafka-topics --list --bootstrap-server localhost:9092

# Create topics manually
INIT_KAFKA_TOPICS.bat
```

### Consul Connection Issues
```bash
# Check Consul members
docker exec revhub-consul consul members

# Check Consul services
curl http://localhost:8500/v1/catalog/services
```

### Database Connection Issues
```bash
# MySQL
docker exec revhub-mysql mysqladmin ping -h localhost -u root -proot

# MongoDB
docker exec revhub-mongo mongosh --eval "db.adminCommand('ping')"
```

### Complete Reset
```bash
# Stop and remove everything
docker-compose down -v

# Remove all RevHub containers
docker rm -f $(docker ps -a -q --filter name=revhub)

# Remove all RevHub images
docker rmi -f $(docker images -q --filter reference=*revhub*)

# Clean system
docker system prune -af --volumes

# Rebuild and start
START_DOCKER.bat
```

## 📊 Service Dependencies

```
Infrastructure Layer:
├── Consul (8500) - Service Discovery
├── Zookeeper (2181) - Kafka Coordinator
├── Kafka (9092/29092) - Message Broker
├── MySQL (3306) - Relational Database
└── MongoDB (27017) - Document Database

Application Layer:
├── API Gateway (8080) → Consul
├── User Service (8081) → Consul + MySQL + Kafka
├── Post Service (8082) → Consul + MySQL + Kafka
├── Social Service (8083) → Consul + MySQL + Kafka
├── Chat Service (8084) → Consul + MongoDB + Kafka
├── Notification Service (8085) → Consul + MongoDB + Kafka
├── Feed Service (8086) → Consul + MongoDB + Kafka
├── Search Service (8087) → Consul + MongoDB + Kafka
└── Saga Orchestrator (8088) → Consul + MySQL + Kafka
```

## ✅ Success Indicators

All services are working when:
- ✅ All containers show "Up" status in `docker ps`
- ✅ All health endpoints return `{"status":"UP"}`
- ✅ Consul UI shows all 9 services registered
- ✅ Kafka has all 7 topics created
- ✅ No error logs in service containers
- ✅ API Gateway can route to all services

## 🎯 Quick Commands

```bash
# Start everything
RESTART_DOCKER.bat

# Check health
CHECK_SERVICES.bat

# Initialize Kafka topics
INIT_KAFKA_TOPICS.bat

# View logs
docker-compose logs -f [service-name]

# Stop everything
docker-compose down

# Rebuild specific service
docker-compose up -d --build [service-name]
```

## 📝 Configuration Files Updated

1. ✅ docker-compose.yml - Added health checks and proper dependencies
2. ✅ RESTART_DOCKER.bat - Complete restart script
3. ✅ CHECK_SERVICES.bat - Health check script
4. ✅ INIT_KAFKA_TOPICS.bat - Kafka topics initialization

## 🔗 Important URLs

- Consul UI: http://localhost:8500
- API Gateway: http://localhost:8080
- User Service: http://localhost:8081
- Post Service: http://localhost:8082
- Social Service: http://localhost:8083
- Chat Service: http://localhost:8084
- Notification Service: http://localhost:8085
- Feed Service: http://localhost:8086
- Search Service: http://localhost:8087
- Saga Orchestrator: http://localhost:8088

---

**All connections are now properly configured! Run RESTART_DOCKER.bat to fix your services.**
