# RevHub Infrastructure

## Components

### Consul
- **Purpose**: Service discovery and health checking
- **Port**: 8500 (UI), 8600 (DNS)
- **Config**: consul/consul-config.json
- **UI**: http://localhost:8500

### Kafka
- **Purpose**: Event streaming between microservices
- **Port**: 9092
- **Topics**: user-events, post-events, social-events, chat-events, notification-events, feed-events, saga-events
- **Setup**: Run kafka/kafka-topics.bat after Kafka starts

### MySQL
- **Purpose**: Relational data (users, follows, likes)
- **Port**: 3306
- **Credentials**: root/root
- **Database**: revhub
- **Init Script**: databases/mysql-init.sql

### MongoDB
- **Purpose**: Document data (posts, messages, notifications, feed)
- **Port**: 27017
- **Credentials**: root/root
- **Database**: revhub
- **Init Script**: databases/mongodb-init.js

### Zookeeper
- **Purpose**: Kafka coordination
- **Port**: 2181

## Setup Order

1. Start infrastructure: `docker-compose up -d consul kafka mysql mongodb zookeeper`
2. Wait 30 seconds for services to be ready
3. Initialize databases: `scripts\setup-databases.bat`
4. Create Kafka topics: `infrastructure\kafka\kafka-topics.bat`
5. Start backend services: `docker-compose up -d [services]`

## Verification

- Consul: http://localhost:8500
- MySQL: `docker exec -it revhub-mysql mysql -uroot -proot`
- MongoDB: `docker exec -it revhub-mongodb mongosh -u root -p root`
- Kafka topics: `docker exec revhub-kafka kafka-topics --list --bootstrap-server localhost:9092`
