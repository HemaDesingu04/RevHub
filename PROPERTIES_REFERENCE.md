# Application Properties Quick Reference

## Service Configuration Summary

### 🔹 API Gateway (Port 8080)
**File**: `backend-services/api-gateway/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8080
spring.application.name=api-gateway
spring.cloud.consul.host=localhost
spring.cloud.gateway.routes[0].id=user-service
spring.cloud.gateway.routes[0].uri=lb://user-service
```

---

### 🔹 User Service (Port 8081)
**File**: `backend-services/user-service/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8081
spring.application.name=user-service
spring.datasource.url=jdbc:mysql://localhost:3306/revhub
spring.datasource.username=root
spring.datasource.password=root
jwt.secret=revhub-secret-key-for-jwt-token-generation-2024
jwt.expiration=86400000
```

---

### 🔹 Post Service (Port 8082)
**File**: `backend-services/post-service/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8082
spring.application.name=post-service
spring.data.mongodb.uri=mongodb://localhost:27017/revhub
spring.data.mongodb.username=root
spring.data.mongodb.password=root
```

---

### 🔹 Social Service (Port 8083)
**File**: `backend-services/social-service/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8083
spring.application.name=social-service
spring.datasource.url=jdbc:mysql://localhost:3306/revhub
```

---

### 🔹 Chat Service (Port 8084)
**File**: `backend-services/chat-service/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8084
spring.application.name=chat-service
spring.data.mongodb.uri=mongodb://localhost:27017/revhub
```

---

### 🔹 Notification Service (Port 8085)
**File**: `backend-services/notification-service/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8085
spring.application.name=notification-service
spring.data.mongodb.uri=mongodb://localhost:27017/revhub
spring.kafka.consumer.group-id=notification-service-group
```

---

### 🔹 Feed Service (Port 8086)
**File**: `backend-services/feed-service/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8086
spring.application.name=feed-service
spring.data.mongodb.uri=mongodb://localhost:27017/revhub
spring.kafka.consumer.group-id=feed-service-group
```

---

### 🔹 Search Service (Port 8087)
**File**: `backend-services/search-service/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8087
spring.application.name=search-service
spring.data.mongodb.uri=mongodb://localhost:27017/revhub
spring.kafka.consumer.group-id=search-service-group
```

---

### 🔹 Saga Orchestrator (Port 8088)
**File**: `backend-services/saga-orchestrator/src/main/resources/application.properties`

**Key Properties**:
```properties
server.port=8088
spring.application.name=saga-orchestrator
spring.datasource.url=jdbc:mysql://localhost:3306/revhub
spring.kafka.consumer.group-id=saga-orchestrator-group
```

---

## Common Properties Across All Services

### Consul Configuration
```properties
spring.cloud.consul.host=${CONSUL_HOST:localhost}
spring.cloud.consul.port=8500
spring.cloud.consul.discovery.service-name=${spring.application.name}
spring.cloud.consul.discovery.health-check-path=/actuator/health
spring.cloud.consul.discovery.instance-id=${spring.application.name}:${server.port}
```

### Kafka Producer Configuration
```properties
spring.kafka.bootstrap-servers=${KAFKA_BOOTSTRAP_SERVERS:localhost:9092}
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.springframework.kafka.support.serializer.JsonSerializer
```

### Kafka Consumer Configuration
```properties
spring.kafka.consumer.group-id=[service-name]-group
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.springframework.kafka.support.serializer.JsonDeserializer
spring.kafka.consumer.properties.spring.json.trusted.packages=*
```

### Management Endpoints
```properties
management.endpoints.web.exposure.include=health,info,metrics
```

---

## Docker Profile Overrides

Each service has `application-docker.properties` that overrides:

```properties
spring.cloud.consul.host=consul
spring.kafka.bootstrap-servers=kafka:9092
```

**MySQL Services**:
```properties
spring.datasource.url=jdbc:mysql://mysql:3306/revhub?useSSL=false&allowPublicKeyRetrieval=true
```

**MongoDB Services**:
```properties
spring.data.mongodb.uri=mongodb://mongodb:27017/revhub
```

---

## Environment Variables

### Override Any Property
```bash
# Windows
set CONSUL_HOST=my-consul-server
set KAFKA_BOOTSTRAP_SERVERS=my-kafka:9092

# Linux/Mac
export CONSUL_HOST=my-consul-server
export KAFKA_BOOTSTRAP_SERVERS=my-kafka:9092
```

### Docker Compose
```yaml
environment:
  SPRING_PROFILES_ACTIVE: docker
  CONSUL_HOST: consul
  KAFKA_BOOTSTRAP_SERVERS: kafka:9092
```

---

## Property Precedence

1. Command line arguments: `--server.port=9090`
2. Environment variables: `SERVER_PORT=9090`
3. Profile-specific properties: `application-docker.properties`
4. Default properties: `application.properties`

---

## Quick Commands

### View Current Configuration
```bash
curl http://localhost:8081/actuator/env
```

### Test with Different Profile
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=docker
```

### Override Property
```bash
java -jar user-service.jar --server.port=9091
```

---

## Troubleshooting

### Property Not Loading
1. Check file name: `application.properties` (not `applications.properties`)
2. Check location: `src/main/resources/`
3. Check syntax: `key=value` (no spaces around `=`)

### Profile Not Active
```bash
# Check active profile
curl http://localhost:8081/actuator/env | grep "activeProfiles"
```

### Database Connection Issues
```properties
# Add logging
logging.level.org.springframework.jdbc=DEBUG
logging.level.org.hibernate.SQL=DEBUG
```

---

**Status**: ✅ All services configured with `.properties` format
