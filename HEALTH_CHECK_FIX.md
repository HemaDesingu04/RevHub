# Health Check Fix - MongoDB Services

## Problem
Post, search, notification, feed, and chat services were showing DOWN status in Consul.

## Root Cause
MongoDB services couldn't resolve the hostname "mongodb" because:
1. Old MongoDB container named `revhub-mongo` was running outside docker-compose network
2. New services created by docker-compose expected container name `revhub-mongodb`
3. Network alias "mongodb" was not configured

## Solution Applied

### 1. Updated docker-compose.yml
- Changed MongoDB container name from `revhub-mongodb` to `revhub-mongo`
- Added network alias `mongodb` so services can resolve it
- Added healthcheck for MongoDB
- Updated all MongoDB-dependent services to wait for `service_healthy` condition

### 2. Recreated Services
```bash
docker stop revhub-mongo && docker rm revhub-mongo
docker-compose up -d mongodb chat-service notification-service feed-service search-service
```

## Verification

All services now show **passing** status in Consul:

✅ api-gateway (8080) - passing
✅ user-service (8081) - passing  
✅ post-service (8082) - passing
✅ social-service (8083) - passing
✅ chat-service (8084) - passing
✅ notification-service (8085) - passing
✅ feed-service (8086) - passing
✅ search-service (8087) - passing
✅ saga-orchestrator (8088) - passing

## Health Endpoints
```bash
curl http://localhost:8082/actuator/health  # {"status":"UP"}
curl http://localhost:8084/actuator/health  # {"status":"UP"}
curl http://localhost:8085/actuator/health  # {"status":"UP"}
curl http://localhost:8086/actuator/health  # {"status":"UP"}
curl http://localhost:8087/actuator/health  # {"status":"UP"}
```

## Status: ✅ RESOLVED
All 9 backend microservices are healthy and registered in Consul.
