# 🤖 AI Prompts for RevHub Microservices

Use these prompts with AI tools (ChatGPT, Claude, etc.) to generate complete working code for each service.

---

## 1. USER SERVICE (Port 8081)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 User Service microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MySQL
- Service Discovery: Consul
- Message Broker: Kafka
- Security: JWT (jjwt 0.12.3)

DATABASE CONFIGURATION:
- URL: jdbc:mysql://localhost:3306/revhub_users?useSSL=false&allowPublicKeyRetrieval=true
- Username: root
- Password: root
- Hibernate DDL: update

ENTITIES:
1. User Entity:
   - id (Long, auto-generated)
   - username (String, unique, not null)
   - email (String, unique, not null)
   - password (String, BCrypt encrypted)
   - firstName (String)
   - lastName (String)
   - bio (String)
   - profilePicture (String, URL)
   - createdAt (LocalDateTime)
   - updatedAt (LocalDateTime)

DTOs:
- UserDTO (without password)
- LoginRequest (username, password)
- RegisterRequest (username, email, password, firstName, lastName)
- AuthResponse (token, UserDTO)

ENDPOINTS:
1. POST /api/users/register - Register new user
   - Input: RegisterRequest
   - Output: AuthResponse (JWT token + user data)
   - Validation: Check username/email uniqueness
   - Password: BCrypt encryption
   - Kafka: Publish USER_REGISTERED event

2. POST /api/users/login - User login
   - Input: LoginRequest
   - Output: AuthResponse (JWT token + user data)
   - Validation: Check credentials
   - JWT: Generate token with 24h expiration

3. GET /api/users/{username} - Get user profile
   - Output: UserDTO
   - Error: 404 if not found

4. PUT /api/users/{username} - Update user profile
   - Input: UserDTO (firstName, lastName, bio, profilePicture)
   - Output: UserDTO
   - Kafka: Publish USER_UPDATED event

5. GET /api/users - Get all users
   - Output: List<UserDTO>

JWT CONFIGURATION:
- Secret: revhub-secret-key-for-jwt-token-generation-2024
- Expiration: 86400000 (24 hours)
- Algorithm: HS256

SECURITY CONFIGURATION:
- Permit: /api/users/register, /api/users/login, /actuator/**
- Require authentication: All other endpoints
- CORS: Allow all origins

KAFKA CONFIGURATION:
- Bootstrap servers: localhost:9092
- Topics: user-events
- Events: USER_REGISTERED, USER_UPDATED

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: user-service
- Health check: /actuator/health

ADDITIONAL REQUIREMENTS:
- Add @CrossOrigin(origins = "*") to all controllers
- Add proper exception handling
- Add validation annotations
- Add Lombok for getters/setters
- Add actuator endpoints
- Server port: 8081

Generate complete code including:
1. pom.xml with all dependencies
2. application.yml with all configurations
3. Main application class
4. All entities with JPA annotations
5. All DTOs
6. Repository interfaces
7. Service layer with business logic
8. Controller with REST endpoints
9. JWT utility class
10. Security configuration
11. Kafka producer configuration
12. Exception handlers
```

---

## 2. POST SERVICE (Port 8082)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 Post Service microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MySQL
- Service Discovery: Consul
- Message Broker: Kafka
- Feign Client: For inter-service communication

DATABASE CONFIGURATION:
- URL: jdbc:mysql://localhost:3306/revhub_posts?useSSL=false&allowPublicKeyRetrieval=true
- Username: root
- Password: root

ENTITIES:
1. Post Entity:
   - id (Long, auto-generated)
   - username (String, not null)
   - content (String, TEXT, not null)
   - imageUrl (String, optional)
   - likesCount (Integer, default 0)
   - commentsCount (Integer, default 0)
   - createdAt (LocalDateTime)
   - updatedAt (LocalDateTime)

DTOs:
- PostDTO (all fields)
- CreatePostRequest (username, content, imageUrl)

ENDPOINTS:
1. POST /api/posts - Create new post
   - Input: CreatePostRequest
   - Output: PostDTO
   - Kafka: Publish POST_CREATED event

2. GET /api/posts/{id} - Get post by ID
   - Output: PostDTO
   - Error: 404 if not found

3. GET /api/posts/user/{username} - Get user's posts
   - Output: List<PostDTO>
   - Sort: By createdAt DESC

4. GET /api/posts - Get all posts (feed)
   - Output: List<PostDTO>
   - Sort: By createdAt DESC

5. PUT /api/posts/{id} - Update post
   - Input: CreatePostRequest
   - Output: PostDTO
   - Kafka: Publish POST_UPDATED event

6. DELETE /api/posts/{id} - Delete post
   - Kafka: Publish POST_DELETED event

7. POST /api/posts/{id}/like - Increment like count
   - Increment likesCount by 1
   - Output: PostDTO

KAFKA CONFIGURATION:
- Bootstrap servers: localhost:9092
- Topics: post-events
- Events: POST_CREATED, POST_UPDATED, POST_DELETED

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: post-service
- Server port: 8082

Generate complete code with all configurations, entities, DTOs, repositories, services, and controllers.
```

---

## 3. SOCIAL SERVICE (Port 8083)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 Social Service microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MySQL
- Service Discovery: Consul
- Message Broker: Kafka

DATABASE CONFIGURATION:
- URL: jdbc:mysql://localhost:3306/revhub_social?useSSL=false&allowPublicKeyRetrieval=true
- Username: root
- Password: root

ENTITIES:
1. Follow Entity:
   - id (Long, auto-generated)
   - followerUsername (String, not null)
   - followingUsername (String, not null)
   - createdAt (LocalDateTime)
   - Unique constraint: (followerUsername, followingUsername)

2. Like Entity:
   - id (Long, auto-generated)
   - username (String, not null)
   - postId (Long, not null)
   - createdAt (LocalDateTime)
   - Unique constraint: (username, postId)

ENDPOINTS:
1. POST /api/social/follow/{following}?follower={username} - Follow user
   - Check if already following
   - Kafka: Publish USER_FOLLOWED event

2. DELETE /api/social/unfollow/{following}?follower={username} - Unfollow user
   - Kafka: Publish USER_UNFOLLOWED event

3. GET /api/social/followers/{username} - Get followers list
   - Output: List<Follow>

4. GET /api/social/following/{username} - Get following list
   - Output: List<Follow>

5. POST /api/social/like/{postId}?username={username} - Like post
   - Check if already liked
   - Kafka: Publish POST_LIKED event

6. DELETE /api/social/unlike/{postId}?username={username} - Unlike post
   - Kafka: Publish POST_UNLIKED event

7. GET /api/social/likes/{postId} - Get post likes
   - Output: List<Like>

KAFKA CONFIGURATION:
- Bootstrap servers: localhost:9092
- Topics: social-events
- Events: USER_FOLLOWED, USER_UNFOLLOWED, POST_LIKED, POST_UNLIKED

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: social-service
- Server port: 8083

Generate complete code with all configurations, entities, repositories, services, and controllers.
```

---

## 4. CHAT SERVICE (Port 8084)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 Chat Service microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MongoDB
- Service Discovery: Consul
- Message Broker: Kafka
- WebSocket: For real-time messaging

DATABASE CONFIGURATION:
- MongoDB URI: mongodb://localhost:27017/revhub_chat

ENTITIES:
1. Message Document:
   - id (String, MongoDB ObjectId)
   - senderUsername (String, not null)
   - receiverUsername (String, not null)
   - content (String, not null)
   - timestamp (LocalDateTime)
   - read (boolean, default false)

ENDPOINTS:
1. POST /api/chat/send - Send message
   - Input: Message
   - Output: Message
   - Kafka: Publish MESSAGE_SENT event

2. GET /api/chat/conversation?user1={u1}&user2={u2} - Get conversation
   - Output: List<Message>
   - Sort: By timestamp ASC
   - Query: Messages between two users (both directions)

3. GET /api/chat/unread/{username} - Get unread messages
   - Output: List<Message>
   - Filter: receiverUsername = username AND read = false

4. PUT /api/chat/read/{messageId} - Mark message as read
   - Update read = true

WEBSOCKET CONFIGURATION:
- Endpoint: /ws/chat
- Message broker: /topic
- Application prefix: /app

KAFKA CONFIGURATION:
- Bootstrap servers: localhost:9092
- Topics: chat-events
- Events: MESSAGE_SENT

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: chat-service
- Server port: 8084

Generate complete code including WebSocket configuration, MongoDB repositories, and real-time messaging support.
```

---

## 5. NOTIFICATION SERVICE (Port 8085)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 Notification Service microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MongoDB
- Service Discovery: Consul
- Message Broker: Kafka (Consumer)

DATABASE CONFIGURATION:
- MongoDB URI: mongodb://localhost:27017/revhub_notifications

ENTITIES:
1. Notification Document:
   - id (String, MongoDB ObjectId)
   - userId (String, not null)
   - fromUserId (String, not null)
   - type (String: LIKE, COMMENT, FOLLOW, MENTION)
   - message (String, not null)
   - postId (String, optional)
   - read (boolean, default false)
   - createdAt (LocalDateTime)

ENDPOINTS:
1. POST /api/notifications - Create notification
   - Input: Notification
   - Output: Notification

2. GET /api/notifications/{userId} - Get user notifications
   - Output: List<Notification>
   - Sort: By createdAt DESC

3. GET /api/notifications/{userId}/unread - Get unread notifications
   - Output: List<Notification>
   - Filter: read = false

4. GET /api/notifications/{userId}/unread-count - Get unread count
   - Output: Long (count)

5. PUT /api/notifications/{notificationId}/read - Mark as read
   - Update read = true

KAFKA CONSUMER:
- Bootstrap servers: localhost:9092
- Group ID: notification-service-group
- Topics: social-events, post-events, user-events
- Auto-create notifications based on events:
  - POST_LIKED → Create LIKE notification
  - USER_FOLLOWED → Create FOLLOW notification
  - POST_COMMENTED → Create COMMENT notification
  - USER_MENTIONED → Create MENTION notification

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: notification-service
- Server port: 8085

Generate complete code including Kafka consumer listeners for automatic notification creation.
```

---

## 6. FEED SERVICE (Port 8086)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 Feed Service microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MongoDB
- Service Discovery: Consul
- Message Broker: Kafka (Consumer)
- Feign Client: For fetching post data

DATABASE CONFIGURATION:
- MongoDB URI: mongodb://localhost:27017/revhub_feed

ENTITIES:
1. FeedItem Document:
   - id (String, MongoDB ObjectId)
   - userId (String, not null)
   - postId (Long, not null)
   - postUsername (String)
   - postContent (String)
   - postImageUrl (String)
   - likesCount (Integer)
   - commentsCount (Integer)
   - postCreatedAt (LocalDateTime)
   - score (Double, for ranking)
   - addedToFeedAt (LocalDateTime)

ENDPOINTS:
1. GET /api/feed/{userId} - Get personalized feed
   - Output: List<FeedItem>
   - Sort: By score DESC, addedToFeedAt DESC

2. GET /api/feed/{userId}/chronological - Get chronological feed
   - Output: List<FeedItem>
   - Sort: By addedToFeedAt DESC

3. POST /api/feed - Add item to feed
   - Input: FeedItem
   - Calculate score based on engagement
   - Output: FeedItem

4. DELETE /api/feed/post/{postId} - Remove post from all feeds
   - Delete all FeedItems with postId

FEED ALGORITHM:
- Score calculation:
  - Recency score: 1.0 (base)
  - Engagement score: (likesCount * 2) + (commentsCount * 3)
  - Final score: recencyScore + (engagementScore * 0.1)

KAFKA CONSUMER:
- Bootstrap servers: localhost:9092
- Group ID: feed-service-group
- Topics: post-events, social-events
- Auto-update feeds based on events:
  - POST_CREATED → Add to followers' feeds
  - POST_DELETED → Remove from all feeds
  - POST_LIKED → Update score
  - POST_COMMENTED → Update score

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: feed-service
- Server port: 8086

Generate complete code including feed algorithm and Kafka consumer for automatic feed updates.
```

---

## 7. SEARCH SERVICE (Port 8087)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 Search Service microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MongoDB with text indexing
- Service Discovery: Consul
- Message Broker: Kafka (Consumer)

DATABASE CONFIGURATION:
- MongoDB URI: mongodb://localhost:27017/revhub_search

ENTITIES:
1. SearchIndex Document:
   - id (String, MongoDB ObjectId)
   - entityType (String: USER, POST)
   - entityId (String, not null)
   - searchableText (String, text indexed)
   - indexedAt (LocalDateTime)

ENDPOINTS:
1. GET /api/search?query={query} - Search all
   - Output: List<SearchIndex>
   - Full-text search on searchableText

2. GET /api/search/{entityType}?query={query} - Search by type
   - Output: List<SearchIndex>
   - Filter by entityType and search

3. POST /api/search/index - Index entity
   - Input: SearchIndex
   - Output: SearchIndex

4. DELETE /api/search/{entityId} - Remove from index
   - Delete by entityId

MONGODB TEXT INDEX:
- Create text index on searchableText field
- Case-insensitive search
- Partial word matching

KAFKA CONSUMER:
- Bootstrap servers: localhost:9092
- Group ID: search-service-group
- Topics: user-events, post-events
- Auto-index based on events:
  - USER_REGISTERED → Index user (username, firstName, lastName, bio)
  - USER_UPDATED → Update user index
  - POST_CREATED → Index post (content)
  - POST_UPDATED → Update post index
  - POST_DELETED → Remove from index

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: search-service
- Server port: 8087

Generate complete code including MongoDB text search and Kafka consumer for automatic indexing.
```

---

## 8. SAGA ORCHESTRATOR (Port 8088)

### Prompt:
```
Generate a complete Spring Boot 3.5.8 Saga Orchestrator microservice with the following specifications:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MySQL
- Service Discovery: Consul
- Message Broker: Kafka
- Feign Client: For calling other services

DATABASE CONFIGURATION:
- URL: jdbc:mysql://localhost:3306/revhub_saga?useSSL=false&allowPublicKeyRetrieval=true
- Username: root
- Password: root

ENTITIES:
1. SagaInstance Entity:
   - id (Long, auto-generated)
   - sagaType (String: CREATE_POST_WITH_NOTIFICATION, DELETE_USER_CASCADE)
   - status (String: STARTED, COMPLETED, FAILED, COMPENSATING)
   - currentStep (String)
   - payload (String, JSON)
   - createdAt (LocalDateTime)
   - updatedAt (LocalDateTime)

ENDPOINTS:
1. POST /api/saga/start - Start saga
   - Input: { sagaType, payload }
   - Output: SagaInstance
   - Kafka: Publish SAGA_STARTED event

2. PUT /api/saga/{sagaId}/step - Update saga step
   - Input: { step, status }
   - Output: SagaInstance

3. POST /api/saga/{sagaId}/complete - Complete saga
   - Update status to COMPLETED
   - Kafka: Publish SAGA_COMPLETED event

4. POST /api/saga/{sagaId}/compensate - Compensate saga
   - Update status to COMPENSATING
   - Rollback all completed steps
   - Kafka: Publish SAGA_COMPENSATING event

5. GET /api/saga/status/{status} - Get sagas by status
   - Output: List<SagaInstance>

SAGA PATTERNS:
1. CREATE_POST_WITH_NOTIFICATION:
   - Step 1: Create post (Post Service)
   - Step 2: Create notification (Notification Service)
   - Step 3: Update feed (Feed Service)
   - Compensation: Delete post, delete notification, remove from feed

2. DELETE_USER_CASCADE:
   - Step 1: Delete user posts (Post Service)
   - Step 2: Delete user follows (Social Service)
   - Step 3: Delete user messages (Chat Service)
   - Step 4: Delete user (User Service)
   - Compensation: Restore all deleted data

KAFKA CONFIGURATION:
- Bootstrap servers: localhost:9092
- Topics: saga-events
- Events: SAGA_STARTED, SAGA_COMPLETED, SAGA_FAILED, SAGA_COMPENSATING

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: saga-orchestrator
- Server port: 8088

Generate complete code including saga orchestration logic, compensation handlers, and Feign clients.
```

---

## 9. API GATEWAY (Port 8080)

### Prompt:
```
Generate a complete Spring Cloud Gateway 4.0.0 API Gateway with the following specifications:

TECHNOLOGY STACK:
- Spring Cloud Gateway: 4.0.0
- Spring Boot: 3.5.8
- Java: 17
- Service Discovery: Consul

ROUTES CONFIGURATION:
1. User Service:
   - Path: /api/users/**
   - URI: lb://user-service
   - Strip prefix: false

2. Post Service:
   - Path: /api/posts/**
   - URI: lb://post-service

3. Social Service:
   - Path: /api/social/**
   - URI: lb://social-service

4. Chat Service:
   - Path: /api/chat/**
   - URI: lb://chat-service

5. Notification Service:
   - Path: /api/notifications/**
   - URI: lb://notification-service

6. Feed Service:
   - Path: /api/feed/**
   - URI: lb://feed-service

7. Search Service:
   - Path: /api/search/**
   - URI: lb://search-service

8. Saga Orchestrator:
   - Path: /api/saga/**
   - URI: lb://saga-orchestrator

CORS CONFIGURATION:
- Allowed origins: http://localhost:4200, http://localhost:4201, http://localhost:4202, http://localhost:4203, http://localhost:4204, http://localhost:4205
- Allowed methods: GET, POST, PUT, DELETE, OPTIONS
- Allowed headers: *
- Allow credentials: true

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: api-gateway
- Discovery enabled: true
- Load balancer enabled: true

GLOBAL FILTERS:
- Add request ID to all requests
- Log all requests and responses
- Add CORS headers

SERVER CONFIGURATION:
- Port: 8080

Generate complete code including:
1. pom.xml with Spring Cloud Gateway dependencies
2. application.yml with all route configurations
3. Main application class
4. CORS configuration
5. Global filters
6. Consul discovery configuration
```

---

## 📝 USAGE INSTRUCTIONS

### How to Use These Prompts:

1. **Copy the prompt** for the service you want to generate
2. **Paste into AI tool** (ChatGPT, Claude, etc.)
3. **Review generated code** and make adjustments
4. **Copy code** into your project structure
5. **Build and test** the service

### Order of Implementation:

1. ✅ API Gateway (first - routes all requests)
2. ✅ User Service (authentication required for others)
3. ✅ Post Service (core functionality)
4. ✅ Social Service (depends on User & Post)
5. ✅ Chat Service (independent)
6. ✅ Notification Service (consumes events)
7. ✅ Feed Service (consumes events)
8. ✅ Search Service (consumes events)
9. ✅ Saga Orchestrator (orchestrates transactions)

### Testing Each Service:

After generating each service:
1. Build: `mvn clean package -DskipTests`
2. Run: `mvn spring-boot:run`
3. Test: `curl http://localhost:[PORT]/actuator/health`
4. Verify in Consul: http://localhost:8500

---

## 🎯 SUCCESS CRITERIA

Each generated service should have:
- ✅ Complete pom.xml with all dependencies
- ✅ application.yml with all configurations
- ✅ Main application class with annotations
- ✅ All entities/documents with proper annotations
- ✅ All DTOs for request/response
- ✅ Repository interfaces
- ✅ Service layer with business logic
- ✅ Controller with REST endpoints
- ✅ Exception handling
- ✅ CORS configuration
- ✅ Consul registration
- ✅ Kafka integration (where applicable)
- ✅ Actuator endpoints

---

## 🚀 READY TO GENERATE!

Use these prompts to quickly generate all microservices with complete functionality! Each prompt is designed to give you production-ready code that follows best practices and integrates seamlessly with the RevHub ecosystem.
