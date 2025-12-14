# API Errors Fix Summary

## Issues Found

### 1. ✅ FIXED: Notifications 500 Error
**Error**: `GET http://localhost:8080/api/notifications 500 (Internal Server Error)`

**Root Cause**: MongoDB authentication failure
```
MongoQueryException: Command failed with error 13 (Unauthorized): 
'command find requires authentication' on server mongodb:27017
```

**Solution**: Updated MongoDB URI in all MongoDB services to include credentials:
```properties
# Before
spring.data.mongodb.uri=mongodb://${MONGODB_HOST:localhost}:27017/${MONGODB_DATABASE:revhub}
spring.data.mongodb.username=root
spring.data.mongodb.password=root
spring.data.mongodb.authentication-database=admin

# After
spring.data.mongodb.uri=mongodb://root:root@${MONGODB_HOST:localhost}:27017/${MONGODB_DATABASE:revhub}?authSource=admin
```

**Files Updated**:
- notification-service/src/main/resources/application.properties
- chat-service/src/main/resources/application.properties
- feed-service/src/main/resources/application.properties
- search-service/src/main/resources/application.properties

**Verification**:
```bash
curl -H "X-User-Id: 12" http://localhost:8085/api/notifications
# Returns: []  (Success!)
```

### 2. ⚠️ Like Endpoint 400 Error
**Error**: `POST http://localhost:8080/api/social/like/30 400 (Bad Request)`

**Root Cause**: Frontend not sending required `username` parameter

**API Endpoint Signature**:
```java
@PostMapping("/like/{postId}")
public ResponseEntity<Like> likePost(
    @RequestParam String username,  // ← Required parameter missing
    @PathVariable Long postId,
    @RequestParam(required = false) String postAuthor
)
```

**Expected Request**:
```
POST /api/social/like/30?username=abhi_123
```

**Current Frontend Request** (from dashboard.component.ts:336):
```
POST /api/social/like/30  // Missing username parameter
```

**Solution Required**: Frontend needs to pass username in query parameter:
```typescript
// In dashboard.component.ts
likePost(postId: number) {
  const username = this.currentUser.username;
  this.http.post(`/api/social/like/${postId}?username=${username}`, {})
    .subscribe(...);
}
```

## Status

✅ **Notifications Service**: Fixed and working
✅ **Chat Service**: MongoDB auth fixed
✅ **Feed Service**: MongoDB auth fixed  
✅ **Search Service**: MongoDB auth fixed
⚠️ **Like Endpoint**: Requires frontend fix to pass username parameter

## Testing

### Notifications (Working)
```bash
curl -H "X-User-Id: 12" http://localhost:8085/api/notifications
# Response: []
```

### Like Endpoint (Needs Frontend Fix)
```bash
# This works:
curl -X POST "http://localhost:8080/api/social/like/30?username=abhi_123"

# Frontend currently sends (missing username):
POST http://localhost:8080/api/social/like/30
```

## Next Steps

1. ✅ MongoDB authentication - COMPLETED
2. ⏳ Update frontend dashboard.component.ts to pass username parameter in like requests
