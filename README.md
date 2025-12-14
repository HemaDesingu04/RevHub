# 🚀 RevHub Microservices Platform

A complete full-stack social media platform built with microservices architecture, featuring 9 backend services and 6 micro-frontends.

## 📋 Overview

RevHub is a production-ready social media application demonstrating modern microservices patterns with:
- **Backend**: 9 Spring Boot microservices
- **Frontend**: 6 Angular micro-frontends with Module Federation
- **Infrastructure**: Consul, Kafka, MySQL, MongoDB
- **Deployment**: Docker containerization

## 🏗️ Architecture

```
Frontend (Angular 18 + Module Federation)
    ↓
API Gateway (Spring Cloud Gateway)
    ↓
9 Microservices (Spring Boot 3.5.8)
    ↓
Infrastructure (Consul + Kafka + MySQL + MongoDB)
```

## 🎯 Features

### User Management
- User registration and authentication
- JWT-based security
- Profile management

### Social Features
- Create and view posts
- Follow/unfollow users
- Like posts and comments
- Personalized feed

### Communication
- Real-time chat messaging
- Notifications system
- Event-driven updates

### Search
- Full-text search for users and posts
- Advanced filtering

## 🚀 Quick Start

### Prerequisites
- Java 17+
- Node.js 18+
- Maven 3.8+
- Docker Desktop
- 16GB RAM recommended

### 🐳 Docker Deployment (Recommended)
```bash
START_DOCKER.bat
```

This will:
1. Build all shared modules
2. Build all backend services
3. Create Docker images
4. Start all containers (infrastructure + backend services)
5. Services run in isolated Docker network

See [Docker Deployment Guide](DOCKER_DEPLOYMENT.md) for details.

### Local Deployment (Alternative)
```bash
START_REVHUB.bat
```

This will:
1. Build all shared modules
2. Build all backend services
3. Start infrastructure (Consul, Kafka, databases)
4. Initialize databases
5. Create Kafka topics
6. Start all backend services (as Java processes)
7. Start all frontend applications

### Manual Start

#### 1. Build Shared Modules
```bash
cd scripts
build-shared-modules.bat
```

#### 2. Build Backend Services
```bash
build-all-services.bat
```

#### 3. Start Infrastructure
```bash
start-infrastructure.bat
```

#### 4. Setup Databases
```bash
setup-databases.bat
```

#### 5. Create Kafka Topics
```bash
cd ..\infrastructure\kafka
kafka-topics.bat
```

#### 6. Start Backend Services
```bash
cd ..\..\scripts
start-backend-services.bat
```

#### 7. Start Frontend Applications
```bash
start-all-frontends.bat
```

## 🌐 Access Points

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:4200 | Main application |
| **API Gateway** | http://localhost:8080 | Backend API |
| **Consul UI** | http://localhost:8500 | Service registry |
| **User Service** | http://localhost:8081 | User management |
| **Post Service** | http://localhost:8082 | Post management |
| **Social Service** | http://localhost:8083 | Social features |
| **Chat Service** | http://localhost:8084 | Messaging |
| **Notification Service** | http://localhost:8085 | Notifications |
| **Feed Service** | http://localhost:8086 | Personalized feeds |
| **Search Service** | http://localhost:8087 | Search functionality |
| **Saga Orchestrator** | http://localhost:8088 | Distributed transactions |

## 📦 Services

### Backend Services

1. **API Gateway** (8080)
   - Routes requests to microservices
   - CORS configuration
   - Load balancing

2. **User Service** (8081)
   - User registration/login
   - JWT authentication
   - Profile management
   - MySQL database

3. **Post Service** (8082)
   - Create/read/update/delete posts
   - Post management
   - MySQL database

4. **Social Service** (8083)
   - Follow/unfollow users
   - Like/unlike posts
   - Social graph
   - MySQL database

5. **Chat Service** (8084)
   - Send/receive messages
   - Conversation management
   - MongoDB database

6. **Notification Service** (8085)
   - User notifications
   - Read/unread status
   - MongoDB database

7. **Feed Service** (8086)
   - Personalized user feeds
   - Chronological feeds
   - MongoDB database

8. **Search Service** (8087)
   - Full-text search
   - User and post search
   - MongoDB database

9. **Saga Orchestrator** (8088)
   - Distributed transactions
   - Saga pattern implementation
   - MySQL database

### Frontend Services

1. **Shell App** (4200)
   - Main container application
   - Navigation and routing
   - Module Federation host

2. **Auth Microfrontend** (4201)
   - Login page
   - Registration page

3. **Feed Microfrontend** (4202)
   - Post feed display
   - Create post form

4. **Profile Microfrontend** (4203)
   - User profile view
   - Profile editing

5. **Chat Microfrontend** (4204)
   - Chat interface
   - Message list

6. **Notifications Microfrontend** (4205)
   - Notification list
   - Mark as read

## 🛠️ Technology Stack

### Backend
- **Framework**: Spring Boot 3.5.8
- **Language**: Java 17
- **Service Discovery**: Consul 1.16
- **Message Broker**: Apache Kafka 7.4.0
- **Databases**: MySQL 8.0, MongoDB 7.0
- **API Gateway**: Spring Cloud Gateway
- **Authentication**: JWT

### Frontend
- **Framework**: Angular 18
- **Architecture**: Micro-frontends (Module Federation)
- **UI Library**: Angular Material 18
- **State Management**: RxJS
- **HTTP Client**: Angular HttpClient

### Infrastructure
- **Containerization**: Docker
- **Orchestration**: Docker Compose
- **Service Discovery**: Consul
- **Message Streaming**: Kafka
- **Databases**: MySQL, MongoDB

## 📁 Project Structure

```
RevHub-Microservices/
├── backend-services/          # 9 Spring Boot microservices
├── frontend-services/         # 6 Angular micro-frontends
├── infrastructure/            # Consul, Kafka, database configs
├── shared/                    # Shared libraries (DTOs, events, utils)
├── scripts/                   # Automation scripts
├── docker-compose.yml         # Container orchestration
└── START_REVHUB.bat          # One-click startup
```

## 🔧 Management Commands

### View Service Logs
```bash
cd scripts
logs.bat
```

### Check Service Health
```bash
health-check.bat
```

### Stop All Services
```bash
stop-all.bat
```

### Clean Build Artifacts
```bash
clean-all.bat
```

## 🧪 Testing

### Test User Flow
1. Open http://localhost:4200
2. Register a new user
3. Login with credentials
4. Create a post
5. View feed
6. Follow other users
7. Send messages
8. Check notifications

### Health Checks
```bash
curl http://localhost:8080/actuator/health  # API Gateway
curl http://localhost:8081/actuator/health  # User Service
# ... check all services
```

## 📊 Database Schemas

### MySQL (revhub)
- `users` - User accounts
- `follows` - Follow relationships
- `likes` - Post likes

### MongoDB (revhub)
- `posts` - User posts
- `messages` - Chat messages
- `notifications` - User notifications
- `feed_items` - Feed items

## 🔄 Event Streaming

### Kafka Topics
1. user-events
2. post-events
3. social-events
4. chat-events
5. notification-events
6. feed-events
7. saga-events

## 🐛 Troubleshooting

### Port Already in Use
```bash
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Docker Issues
```bash
docker-compose down -v
docker system prune -f
```

### Frontend Build Errors
```bash
cd frontend-services\[service-name]
rmdir /s node_modules
npm cache clean --force
npm install
```

## 📚 Documentation

- [Docker Deployment Guide](DOCKER_DEPLOYMENT.md) 🐳 **NEW**
- [Docker Quick Reference](DOCKER_QUICK_REFERENCE.md) 🐳 **NEW**
- [Quick Start Guide](QUICK_START.md)
- [Implementation Status](IMPLEMENTATION_STATUS.md)
- [Infrastructure Guide](infrastructure/README.md)
- [Shared Modules](shared/README.md)
- [Scripts Documentation](scripts/README.md)
- [Final Validation](FINAL_VALIDATION.md)

## 🎯 Success Metrics

✅ 9 backend microservices running
✅ 6 frontend micro-frontends running
✅ Service discovery active
✅ Event streaming working
✅ Databases initialized
✅ CORS configured
✅ JWT authentication
✅ Full Docker containerization 🐳
✅ Production-ready deployment

## 🏆 Status

**Implementation: 100% Complete**
**Status: Production Ready**

## 📝 License

This project is for educational and demonstration purposes.

## 👥 Contributing

This is a complete reference implementation. Feel free to use it as a template for your own microservices projects.

## 🚀 Get Started Now!

### Docker (Recommended)
```bash
START_DOCKER.bat
```

### Local
```bash
START_REVHUB.bat
```

Then open http://localhost:4200 in your browser!

---

**Built with ❤️ using Spring Boot, Angular, and Microservices Architecture**
