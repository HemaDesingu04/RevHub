# 🏗️ RevHub Infrastructure Guide

## Overview

RevHub uses a microservices infrastructure with service discovery, message streaming, and multiple databases.

## Components

### 1. Consul (Service Discovery)
**Port**: 8500  
**Purpose**: Service registration, discovery, and health checking

**Features**:
- Automatic service registration
- Health monitoring
- DNS-based service discovery
- Key-value store

**Access**:
```
UI: http://localhost:8500
API: http://localhost:8500/v1/
```

**Configuration**:
```properties
spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.service-name=user-service
```

### 2. Apache Kafka (Event Streaming)
**Port**: 9092  
**Purpose**: Asynchronous event-driven communication

**Topics**:
1. `user-events` - User registration, updates
2. `post-events` - Post creation, updates, deletion
3. `social-events` - Follow, like, comment events
4. `chat-events` - Message events
5. `notification-events` - Notification triggers
6. `feed-events` - Feed updates
7. `saga-events` - Distributed transaction events

**Create Topics**:
```bash
cd infrastructure/kafka
kafka-topics.bat
```

**List Topics**:
```bash
docker exec revhub-kafka kafka-topics --list --bootstrap-server localhost:9092
```

**Configuration**:
```properties
spring.kafka.bootstrap-servers=localhost:9092
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.springframework.kafka.support.serializer.JsonSerializer
```

### 3. MySQL (Relational Database)
**Port**: 3306  
**Purpose**: Structured data storage

**Databases**:
- `revhub` - Main database

**Tables**:
- `users` - User accounts
- `follows` - Follow relationships
- `likes` - Post likes

**Access**:
```bash
docker exec -it revhub-mysql mysql -uroot -proot
```

**Configuration**:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/revhub
spring.datasource.username=root
spring.datasource.password=root
```

**Initialization**:
```bash
docker exec -i revhub-mysql mysql -uroot -proot < infrastructure/databases/mysql-init.sql
```

### 4. MongoDB (Document Database)
**Port**: 27017  
**Purpose**: Flexible document storage

**Collections**:
- `posts` - User posts
- `messages` - Chat messages
- `notifications` - User notifications
- `feed_items` - Feed items

**Access**:
```bash
docker exec -it revhub-mongodb mongosh -u root -p root --authenticationDatabase admin
```

**Configuration**:
```properties
spring.data.mongodb.uri=mongodb://localhost:27017/revhub
spring.data.mongodb.username=root
spring.data.mongodb.password=root
```

**Initialization**:
```bash
docker exec -i revhub-mongodb mongosh -u root -p root --authenticationDatabase admin < infrastructure/databases/mongodb-init.js
```

### 5. Zookeeper (Kafka Coordination)
**Port**: 2181  
**Purpose**: Kafka cluster coordination

**Configuration**:
```yaml
ZOOKEEPER_CLIENT_PORT: 2181
ZOOKEEPER_TICK_TIME: 2000
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Frontend Layer                        │
│              (Angular Micro-frontends)                   │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                     API Gateway                          │
│              (Spring Cloud Gateway)                      │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                  Service Discovery                       │
│                     (Consul)                             │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                  Microservices Layer                     │
│  User │ Post │ Social │ Chat │ Notification │ Feed      │
│  Search │ Saga Orchestrator                             │
└─────────────────────────────────────────────────────────┘
         ↓                ↓                    ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│    MySQL     │  │   MongoDB    │  │    Kafka     │
│  (Relational)│  │  (Document)  │  │  (Streaming) │
└──────────────┘  └──────────────┘  └──────────────┘
```

## Network Configuration

### Docker Network
```yaml
networks:
  revhub-network:
    driver: bridge
```

All services communicate through `revhub-network`.

### Service Communication

**Synchronous (REST)**:
- Frontend → API Gateway → Services
- Service → Service (via Feign Client)

**Asynchronous (Kafka)**:
- Service → Kafka → Service
- Event-driven updates

## Data Flow

### User Registration
```
1. Frontend → API Gateway → User Service
2. User Service → MySQL (save user)
3. User Service → Kafka (user-events)
4. Notification Service ← Kafka (send welcome notification)
5. Feed Service ← Kafka (initialize feed)
```

### Post Creation
```
1. Frontend → API Gateway → Post Service
2. Post Service → MongoDB (save post)
3. Post Service → Kafka (post-events)
4. Feed Service ← Kafka (update followers' feeds)
5. Search Service ← Kafka (index post)
```

### Follow User
```
1. Frontend → API Gateway → Social Service
2. Social Service → MySQL (save follow relationship)
3. Social Service → Kafka (social-events)
4. Notification Service ← Kafka (notify followed user)
5. Feed Service ← Kafka (update follower's feed)
```

## Monitoring & Health

### Health Endpoints
```bash
# Consul
curl http://localhost:8500/v1/health/state/any

# Services
curl http://localhost:8081/actuator/health
curl http://localhost:8082/actuator/health
```

### Metrics
```bash
curl http://localhost:8081/actuator/metrics
```

### Consul UI
```
http://localhost:8500/ui/dc1/services
```

## Scaling Strategy

### Horizontal Scaling
```bash
# Scale user service to 3 instances
docker-compose up -d --scale user-service=3
```

### Load Balancing
- API Gateway uses Consul for service discovery
- Automatically load balances across instances
- Round-robin by default

### Database Scaling
- MySQL: Master-slave replication
- MongoDB: Replica sets
- Kafka: Add more brokers

## Backup Strategy

### MySQL Backup
```bash
# Daily backup
docker exec revhub-mysql mysqldump -uroot -proot revhub > backup-$(date +%Y%m%d).sql

# Restore
docker exec -i revhub-mysql mysql -uroot -proot revhub < backup.sql
```

### MongoDB Backup
```bash
# Backup
docker exec revhub-mongodb mongodump --username root --password root --authenticationDatabase admin --out /backup

# Restore
docker exec revhub-mongodb mongorestore --username root --password root --authenticationDatabase admin /backup
```

### Kafka Backup
- Use Kafka MirrorMaker for replication
- Configure retention policies

## Security

### Network Security
```yaml
# Restrict external access
ports:
  - "127.0.0.1:3306:3306"  # MySQL only localhost
  - "127.0.0.1:27017:27017"  # MongoDB only localhost
```

### Database Security
```properties
# Use strong passwords
spring.datasource.password=${DB_PASSWORD}

# Enable SSL
spring.datasource.url=jdbc:mysql://localhost:3306/revhub?useSSL=true
```

### Kafka Security
```properties
# Enable SASL/SSL
spring.kafka.security.protocol=SASL_SSL
spring.kafka.properties.sasl.mechanism=PLAIN
```

## Troubleshooting

### Consul Not Registering Services
```bash
# Check Consul
docker logs revhub-consul

# Check service logs
docker logs revhub-user-service

# Verify network
docker network inspect revhub-network
```

### Kafka Connection Issues
```bash
# Check Kafka
docker logs revhub-kafka

# Check Zookeeper
docker logs revhub-zookeeper

# Test connection
docker exec revhub-kafka kafka-broker-api-versions --bootstrap-server localhost:9092
```

### Database Connection Issues
```bash
# MySQL
docker exec revhub-mysql mysqladmin -uroot -proot ping

# MongoDB
docker exec revhub-mongodb mongosh --eval "db.adminCommand('ping')"
```

## Performance Tuning

### MySQL
```sql
-- Increase connection pool
SET GLOBAL max_connections = 500;

-- Enable query cache
SET GLOBAL query_cache_size = 67108864;
```

### MongoDB
```javascript
// Create indexes
db.posts.createIndex({ userId: 1, createdAt: -1 });
db.messages.createIndex({ senderId: 1, receiverId: 1 });
```

### Kafka
```properties
# Increase throughput
spring.kafka.producer.batch-size=32768
spring.kafka.producer.buffer-memory=67108864
```

## Quick Reference

### Start Infrastructure
```bash
docker-compose -f docker-compose-minimal.yml up -d
```

### Stop Infrastructure
```bash
docker-compose -f docker-compose-minimal.yml down
```

### View All Logs
```bash
docker-compose logs -f
```

### Clean Everything
```bash
docker-compose down -v
docker system prune -a
```

---

**Status**: Infrastructure Ready ✅
