# 🚀 RevHub Deployment Guide

## Deployment Options

### Option 1: Full Docker Deployment (Recommended)
Deploy everything with Docker Compose.

```bash
# Build and start all services
docker-compose up --build -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f [service-name]

# Stop all
docker-compose down
```

### Option 2: Infrastructure + Local Services
Run infrastructure in Docker, services locally.

```bash
# Start infrastructure only
docker-compose -f docker-compose-minimal.yml up -d

# Build and run services locally
cd scripts
build-shared-modules.bat
build-all-services.bat

# Run each service
cd backend-services/user-service
mvn spring-boot:run

# Run frontends
cd frontend-services/shell-app
npm install && npm start
```

### Option 3: Separate Frontend/Backend
Deploy frontend and backend separately.

```bash
# Start infrastructure + backend
docker-compose up -d consul kafka mysql mongodb zookeeper api-gateway user-service post-service social-service chat-service notification-service feed-service search-service saga-orchestrator

# Start frontend separately
docker-compose -f docker-compose.frontend.yml up -d
```

## Environment Configuration

### Development
```bash
# Use default application.properties
mvn spring-boot:run
```

### Docker
```bash
# Uses application-docker.properties automatically
docker-compose up -d
```

### Production
```bash
# Set environment variables
export SPRING_PROFILES_ACTIVE=prod
export CONSUL_HOST=prod-consul.example.com
export KAFKA_BOOTSTRAP_SERVERS=prod-kafka.example.com:9092
export DB_HOST=prod-mysql.example.com
export MONGODB_HOST=prod-mongodb.example.com

# Run services
java -jar user-service.jar
```

## Port Mapping

| Service | Port | Protocol |
|---------|------|----------|
| Shell App | 4200 | HTTP |
| Auth MFE | 4201 | HTTP |
| Feed MFE | 4202 | HTTP |
| Profile MFE | 4203 | HTTP |
| Chat MFE | 4204 | HTTP |
| Notifications MFE | 4205 | HTTP |
| API Gateway | 8080 | HTTP |
| User Service | 8081 | HTTP |
| Post Service | 8082 | HTTP |
| Social Service | 8083 | HTTP |
| Chat Service | 8084 | HTTP |
| Notification Service | 8085 | HTTP |
| Feed Service | 8086 | HTTP |
| Search Service | 8087 | HTTP |
| Saga Orchestrator | 8088 | HTTP |
| Consul | 8500 | HTTP |
| MySQL | 3306 | TCP |
| MongoDB | 27017 | TCP |
| Kafka | 9092 | TCP |
| Zookeeper | 2181 | TCP |

## Health Checks

### Check All Services
```bash
cd scripts
health-check.bat
```

### Individual Service
```bash
curl http://localhost:8081/actuator/health
```

### Consul UI
```
http://localhost:8500
```

## Scaling Services

### Scale Specific Service
```bash
docker-compose up -d --scale user-service=3
```

### Load Balancing
API Gateway automatically load balances across instances via Consul.

## Database Initialization

### MySQL
```bash
docker exec -i revhub-mysql mysql -uroot -proot < infrastructure/databases/mysql-init.sql
```

### MongoDB
```bash
docker exec -i revhub-mongodb mongosh -u root -p root --authenticationDatabase admin < infrastructure/databases/mongodb-init.js
```

## Kafka Topics

### Create Topics
```bash
cd infrastructure/kafka
kafka-topics.bat
```

### List Topics
```bash
docker exec revhub-kafka kafka-topics --list --bootstrap-server localhost:9092
```

## Troubleshooting

### Service Won't Start
```bash
# Check logs
docker logs revhub-user-service

# Check if port is in use
netstat -ano | findstr :8081

# Restart service
docker-compose restart user-service
```

### Database Connection Issues
```bash
# Check if database is running
docker ps | findstr mysql

# Test connection
docker exec -it revhub-mysql mysql -uroot -proot -e "SELECT 1"
```

### Consul Registration Issues
```bash
# Check Consul
curl http://localhost:8500/v1/catalog/services

# Re-register service
docker-compose restart user-service
```

## Backup & Restore

### Backup MySQL
```bash
docker exec revhub-mysql mysqldump -uroot -proot revhub > backup.sql
```

### Restore MySQL
```bash
docker exec -i revhub-mysql mysql -uroot -proot revhub < backup.sql
```

### Backup MongoDB
```bash
docker exec revhub-mongodb mongodump --username root --password root --authenticationDatabase admin --out /backup
```

## Monitoring

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f user-service

# Last 100 lines
docker-compose logs --tail=100 user-service
```

### Resource Usage
```bash
docker stats
```

## Security Considerations

1. **Change Default Passwords**
   - MySQL: root/root
   - MongoDB: root/root
   - JWT Secret

2. **Enable HTTPS**
   - Add SSL certificates
   - Configure reverse proxy (Nginx/Traefik)

3. **Network Security**
   - Use Docker networks
   - Restrict port access
   - Enable firewall rules

4. **Secrets Management**
   - Use Docker secrets
   - Environment variables
   - External secret managers (Vault)

## Production Checklist

- [ ] Change all default passwords
- [ ] Configure SSL/TLS
- [ ] Set up monitoring (Prometheus/Grafana)
- [ ] Configure log aggregation (ELK)
- [ ] Set up backups
- [ ] Configure auto-scaling
- [ ] Set resource limits
- [ ] Enable health checks
- [ ] Configure alerts
- [ ] Document runbooks

## Quick Commands

```bash
# Start everything
docker-compose up -d

# Stop everything
docker-compose down

# Rebuild and restart
docker-compose up --build -d

# View logs
docker-compose logs -f

# Clean everything
docker-compose down -v
docker system prune -a
```

---

**Status**: Ready for Deployment 🚀
