# RevHub Scripts

## Build Scripts

### build-shared-modules.bat
Builds all shared modules (common-dto, event-schemas, utilities).
**Run first** before building backend services.

### build-all-services.bat
Builds all 9 backend microservices.
Requires shared modules to be built first.

## Infrastructure Scripts

### start-infrastructure.bat
Starts Consul, Kafka, MySQL, MongoDB, Zookeeper.
Waits 30 seconds for services to be ready.

### setup-databases.bat
Initializes MySQL and MongoDB with schemas.
Run after infrastructure is started.

## Service Management Scripts

### start-backend-services.bat
Starts all 9 backend microservices.
Waits 45 seconds and performs health checks.

### start-all-frontends.bat
Opens 6 terminal windows for all frontend services.
Each runs on its own port (4200-4205).

### complete-setup.bat
Runs all setup steps in sequence:
1. Build shared modules
2. Build backend services
3. Start infrastructure
4. Start backend services
5. Start frontends

### stop-all.bat
Stops all Docker containers.
Use `docker-compose down -v` to also remove volumes.

## Utility Scripts

### health-check.bat
Checks health of all services.
Displays status of infrastructure and microservices.

### logs.bat
Interactive script to view logs of any service.
Follows logs in real-time.

### clean-all.bat
Removes all build artifacts:
- Backend target/ folders
- Shared modules target/ folders
- Frontend node_modules/ and dist/ folders

## Kafka Scripts

### infrastructure/kafka/kafka-topics.bat
Creates all required Kafka topics.
Run after Kafka is started.

## Recommended Execution Order

1. `build-shared-modules.bat`
2. `build-all-services.bat`
3. `start-infrastructure.bat`
4. `setup-databases.bat`
5. `infrastructure\kafka\kafka-topics.bat`
6. `start-backend-services.bat`
7. `start-all-frontends.bat`

Or simply run: `complete-setup.bat`

## Quick Commands

**Full setup**: `complete-setup.bat`
**Stop everything**: `stop-all.bat`
**Check health**: `health-check.bat`
**View logs**: `logs.bat`
**Clean build**: `clean-all.bat`
