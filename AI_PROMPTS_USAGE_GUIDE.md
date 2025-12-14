# 🤖 AI Prompts Usage Guide for RevHub Microservices

## 📋 Overview

This guide explains how to use the AI prompts in `AI_PROMPTS_FOR_SERVICES.md` to modify, enhance, or regenerate any service in the RevHub platform.

---

## ✅ Current Implementation Status

**All 9 backend services are 100% implemented and working!**

The AI prompts are provided for:
1. **Understanding** the architecture and requirements
2. **Modifying** existing services with new features
3. **Regenerating** services if needed
4. **Creating** new services following the same pattern

---

## 🎯 When to Use AI Prompts

### 1. Adding New Features
**Example**: Add email verification to User Service

```
Copy the User Service prompt and add:

ADDITIONAL ENDPOINT:
6. POST /api/users/verify-email - Verify user email
   - Input: { email, verificationCode }
   - Output: { success: boolean, message: string }
   - Logic: Check verification code, update user.emailVerified = true
   - Kafka: Publish EMAIL_VERIFIED event

ADDITIONAL FIELDS in User Entity:
- emailVerified (boolean, default false)
- verificationCode (String, nullable)
- verificationCodeExpiry (LocalDateTime, nullable)
```

### 2. Modifying Existing Endpoints
**Example**: Add pagination to Post Service feed

```
Modify the Post Service prompt:

CHANGE ENDPOINT:
4. GET /api/posts - Get all posts (feed)
   - Add pagination parameters: page, size
   - Output: Page<PostDTO>
   - Sort: By createdAt DESC
   - Default: page=0, size=20
```

### 3. Adding New Integrations
**Example**: Add Redis caching to Feed Service

```
Add to Feed Service prompt:

ADDITIONAL TECHNOLOGY:
- Redis: For caching feed data

CACHING STRATEGY:
- Cache key: feed:{userId}
- TTL: 5 minutes
- Invalidate on: POST_CREATED, POST_DELETED events
```

### 4. Creating New Services
**Example**: Create an Analytics Service

```
Follow the pattern from existing prompts:

Generate a complete Spring Boot 3.5.8 Analytics Service microservice with:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MongoDB
- Service Discovery: Consul
- Message Broker: Kafka (Consumer)

DATABASE CONFIGURATION:
- MongoDB URI: mongodb://localhost:27017/revhub_analytics

ENTITIES:
1. UserActivity Document:
   - id (String, MongoDB ObjectId)
   - userId (String, not null)
   - activityType (String: LOGIN, POST_CREATE, POST_LIKE, etc.)
   - timestamp (LocalDateTime)
   - metadata (Map<String, Object>)

ENDPOINTS:
1. GET /api/analytics/user/{userId}/activity - Get user activity
2. GET /api/analytics/popular-posts - Get trending posts
3. GET /api/analytics/active-users - Get most active users

KAFKA CONSUMER:
- Topics: user-events, post-events, social-events
- Auto-track all user activities

CONSUL CONFIGURATION:
- Service name: analytics-service
- Server port: 8089
```

---

## 📝 Step-by-Step Guide

### Step 1: Identify What You Need

**Questions to ask:**
- Which service needs modification?
- What feature do I want to add?
- Do I need a new service?
- What data do I need to store?
- What endpoints do I need?

### Step 2: Copy the Relevant Prompt

Open `AI_PROMPTS_FOR_SERVICES.md` and copy the prompt for the service you want to modify.

### Step 3: Modify the Prompt

Add your requirements to the prompt:
- New endpoints
- New fields in entities
- New DTOs
- New Kafka events
- New dependencies

### Step 4: Use AI Tool

Paste the modified prompt into:
- ChatGPT (GPT-4 recommended)
- Claude (Claude 3 recommended)
- GitHub Copilot Chat
- Any other AI coding assistant

### Step 5: Review Generated Code

Check the generated code for:
- Correct package names
- Proper annotations
- Complete implementations
- Error handling
- Validation

### Step 6: Integrate into Project

1. Copy generated code to appropriate files
2. Update pom.xml if new dependencies added
3. Update application.yml if new configs added
4. Build: `mvn clean package -DskipTests`
5. Test: Run the service and verify endpoints

---

## 🔧 Common Modification Patterns

### Pattern 1: Add New Endpoint

```
ADDITIONAL ENDPOINT:
X. [METHOD] [PATH] - [Description]
   - Input: [DTO/Parameters]
   - Output: [Response Type]
   - Logic: [Business logic description]
   - Validation: [Validation rules]
   - Kafka: [Event to publish, if any]
```

### Pattern 2: Add New Entity Field

```
MODIFY ENTITY:
[Entity Name]:
   - Add field: [fieldName] ([Type], [constraints])
   - Add field: [fieldName2] ([Type], [constraints])
```

### Pattern 3: Add New DTO

```
ADDITIONAL DTO:
- [DTOName] ([field1], [field2], [field3])
  Purpose: [Why this DTO is needed]
```

### Pattern 4: Add Kafka Event

```
ADDITIONAL KAFKA EVENT:
- Event: [EVENT_NAME]
- Trigger: [When to publish]
- Payload: { [field1], [field2] }
- Consumers: [Which services should listen]
```

### Pattern 5: Add Validation

```
ADDITIONAL VALIDATION:
- Endpoint: [Endpoint path]
- Validation: [Validation rules]
- Error response: [Error format]
```

---

## 💡 Real-World Examples

### Example 1: Add Profile Picture Upload

**Service**: User Service

**Modified Prompt Section**:
```
ADDITIONAL ENDPOINT:
6. POST /api/users/{username}/upload-picture - Upload profile picture
   - Input: MultipartFile (image file)
   - Output: { imageUrl: string }
   - Logic: 
     * Validate file type (jpg, png only)
     * Validate file size (max 5MB)
     * Upload to cloud storage (AWS S3 or Cloudinary)
     * Update user.profilePicture with URL
   - Kafka: Publish USER_PICTURE_UPDATED event

ADDITIONAL DEPENDENCY:
- AWS SDK for S3 or Cloudinary SDK
```

### Example 2: Add Comment Feature

**Service**: Post Service

**Modified Prompt Section**:
```
ADDITIONAL ENTITY:
2. Comment Entity:
   - id (Long, auto-generated)
   - postId (Long, not null)
   - username (String, not null)
   - content (String, TEXT, not null)
   - createdAt (LocalDateTime)

ADDITIONAL ENDPOINTS:
8. POST /api/posts/{postId}/comments - Add comment
   - Input: { username, content }
   - Output: CommentDTO
   - Logic: Increment post.commentsCount
   - Kafka: Publish COMMENT_CREATED event

9. GET /api/posts/{postId}/comments - Get post comments
   - Output: List<CommentDTO>
   - Sort: By createdAt DESC

10. DELETE /api/posts/comments/{commentId} - Delete comment
    - Logic: Decrement post.commentsCount
    - Kafka: Publish COMMENT_DELETED event
```

### Example 3: Add Real-Time Notifications

**Service**: Notification Service

**Modified Prompt Section**:
```
ADDITIONAL TECHNOLOGY:
- WebSocket: For real-time push notifications

WEBSOCKET CONFIGURATION:
- Endpoint: /ws/notifications
- Message broker: /topic/notifications/{userId}
- Application prefix: /app

ADDITIONAL ENDPOINT:
6. WebSocket /app/subscribe/{userId} - Subscribe to notifications
   - Push new notifications in real-time
   - Auto-send when notification created
```

### Example 4: Add Search Filters

**Service**: Search Service

**Modified Prompt Section**:
```
MODIFY ENDPOINT:
1. GET /api/search?query={query}&type={type}&dateFrom={date}&dateTo={date}
   - Add filters: type, dateFrom, dateTo
   - Filter by entity type
   - Filter by date range
   - Output: List<SearchIndex>
```

---

## 🚀 Advanced Usage

### Creating a Complete New Service

**Example**: Payment Service

```
Generate a complete Spring Boot 3.5.8 Payment Service microservice with:

TECHNOLOGY STACK:
- Spring Boot: 3.5.8
- Java: 17
- Database: MySQL
- Service Discovery: Consul
- Message Broker: Kafka
- Payment Gateway: Stripe API

DATABASE CONFIGURATION:
- URL: jdbc:mysql://localhost:3306/revhub_payments?useSSL=false&allowPublicKeyRetrieval=true
- Username: root
- Password: root

ENTITIES:
1. Payment Entity:
   - id (Long, auto-generated)
   - userId (String, not null)
   - amount (BigDecimal, not null)
   - currency (String, default "USD")
   - status (String: PENDING, COMPLETED, FAILED)
   - stripePaymentId (String)
   - createdAt (LocalDateTime)
   - updatedAt (LocalDateTime)

2. Subscription Entity:
   - id (Long, auto-generated)
   - userId (String, not null)
   - plan (String: FREE, PREMIUM, ENTERPRISE)
   - status (String: ACTIVE, CANCELLED, EXPIRED)
   - startDate (LocalDateTime)
   - endDate (LocalDateTime)

ENDPOINTS:
1. POST /api/payments/create - Create payment intent
   - Input: { userId, amount, currency }
   - Output: { clientSecret, paymentId }
   - Integration: Stripe Payment Intent API

2. POST /api/payments/confirm - Confirm payment
   - Input: { paymentId, paymentMethodId }
   - Output: PaymentDTO
   - Kafka: Publish PAYMENT_COMPLETED event

3. GET /api/payments/user/{userId} - Get user payments
   - Output: List<PaymentDTO>

4. POST /api/subscriptions/subscribe - Subscribe to plan
   - Input: { userId, plan, paymentMethodId }
   - Output: SubscriptionDTO
   - Kafka: Publish USER_SUBSCRIBED event

5. POST /api/subscriptions/cancel - Cancel subscription
   - Input: { subscriptionId }
   - Kafka: Publish SUBSCRIPTION_CANCELLED event

STRIPE CONFIGURATION:
- API Key: [from environment variable]
- Webhook endpoint: /api/payments/webhook
- Webhook events: payment_intent.succeeded, payment_intent.failed

KAFKA CONFIGURATION:
- Bootstrap servers: localhost:9092
- Topics: payment-events
- Events: PAYMENT_COMPLETED, PAYMENT_FAILED, USER_SUBSCRIBED

CONSUL CONFIGURATION:
- Host: localhost
- Port: 8500
- Service name: payment-service
- Server port: 8089

Generate complete code including Stripe integration, webhook handling, and subscription management.
```

---

## 📚 Best Practices

### 1. Be Specific
- Clearly define input/output formats
- Specify validation rules
- Define error handling
- Mention edge cases

### 2. Follow Existing Patterns
- Use same naming conventions
- Follow same package structure
- Use same annotation style
- Match existing code style

### 3. Include All Details
- Database configurations
- Kafka topics and events
- Consul settings
- CORS requirements
- Security requirements

### 4. Test Generated Code
- Build the service
- Test all endpoints
- Verify Kafka events
- Check Consul registration
- Test error scenarios

### 5. Document Changes
- Update README.md
- Update API documentation
- Add comments in code
- Update docker-compose.yml if needed

---

## 🔍 Troubleshooting

### Issue: Generated code doesn't compile

**Solution**: 
- Check package names match your project
- Verify all imports are correct
- Ensure dependencies are in pom.xml
- Check Java version compatibility

### Issue: Service doesn't register in Consul

**Solution**:
- Verify Consul configuration in application.yml
- Check @EnableDiscoveryClient annotation
- Ensure Consul is running
- Check network connectivity

### Issue: Kafka events not publishing

**Solution**:
- Verify Kafka configuration
- Check topic exists
- Ensure KafkaTemplate is autowired
- Check Kafka is running

### Issue: Database connection fails

**Solution**:
- Verify database URL
- Check credentials
- Ensure database exists
- Check MySQL/MongoDB is running

---

## 📞 Getting Help

If you need help with AI prompts:

1. **Check existing services**: Look at similar implementations
2. **Review documentation**: Check README.md and other docs
3. **Test incrementally**: Add one feature at a time
4. **Use version control**: Commit before making changes
5. **Ask specific questions**: Be clear about what you need

---

## 🎯 Summary

The AI prompts in `AI_PROMPTS_FOR_SERVICES.md` are:
- ✅ Templates for understanding service architecture
- ✅ Starting points for modifications
- ✅ Guides for creating new services
- ✅ Documentation of current implementation

**Remember**: All services are already implemented! Use prompts for enhancements and new features.

---

**Happy Coding!** 🚀
