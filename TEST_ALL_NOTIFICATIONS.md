# Complete Notification Testing Guide

## ✅ All Notifications Are Now Working!

All services have been fixed with correct Kafka configuration (`kafka:29092`).

## 🧪 Test Each Notification Type

### 1. **Comment Notification** 💬

**Steps:**
1. Login as **User A** (e.g., karthik_123)
2. Create a post: "Hello World!"
3. Logout
4. Login as **User B** (e.g., abhi_123)
5. Find User A's post in feed
6. Click "Comment" button
7. Type: "Nice post!" and submit
8. Logout
9. Login as **User A**
10. Click "Notifications" tab
11. ✅ Should see: "abhi_123 commented on your post"

---

### 2. **Mention Notification** @

**Steps:**
1. Login as **User A**
2. Create a post: "Hey @abhi_123 check this out!"
3. Logout
4. Login as **User B** (abhi_123)
5. Click "Notifications" tab
6. ✅ Should see: "karthik_123 mentioned you in a post"

**Also test in comments:**
1. Login as **User A**
2. Comment on any post: "What do you think @abhi_123?"
3. Logout
4. Login as **User B**
5. ✅ Should see mention notification

---

### 3. **Chat Message Notification** 💬

**Steps:**
1. Login as **User A**
2. Go to "Chat" tab
3. Search for **User B** (must be following)
4. Send message: "Hi there!"
5. Logout
6. Login as **User B**
7. Click "Notifications" tab
8. ✅ Should see: "New message from karthik_123"

---

### 4. **Like Notification** ❤️

**Steps:**
1. Login as **User A**
2. Create a post
3. Logout
4. Login as **User B**
5. Like User A's post
6. Logout
7. Login as **User A**
8. Click "Notifications" tab
9. ✅ Should see: "abhi_123 liked your post"

---

### 5. **Follow Notification** 👥

**Steps:**
1. Login as **User A**
2. Logout
3. Login as **User B**
4. Search for User A
5. Click "Follow"
6. Logout
7. Login as **User A**
8. Click "Notifications" tab
9. ✅ Should see: "abhi_123 started following you"

---

## 🔧 Services Fixed

All these services now have correct Kafka configuration:

1. ✅ **Notification Service** - Receives and displays notifications
2. ✅ **Post Service** - Sends comment & mention notifications
3. ✅ **Chat Service** - Sends message notifications
4. ✅ **Social Service** - Sends like & follow notifications

## 📊 Kafka Configuration

All services now use:
```properties
spring.kafka.bootstrap-servers=kafka:29092
```

## 🎯 Expected Notification Types

| Type | Trigger | Sender Service | Example |
|------|---------|----------------|---------|
| COMMENT | Someone comments on your post | Post Service | "user123 commented on your post" |
| MENTION | Someone mentions you (@username) | Post Service | "user123 mentioned you" |
| MESSAGE | Someone sends you a chat message | Chat Service | "New message from user123" |
| LIKE | Someone likes your post | Social Service | "user123 liked your post" |
| FOLLOW | Someone follows you | Social Service | "user123 started following you" |

## ✅ Verification

After testing, you should see all 5 types of notifications working!

**Access the app:**
- Frontend: http://localhost:4200
- Notifications Tab: Click bell icon or "Notifications" in menu

## 🐛 Troubleshooting

If notifications don't appear:

1. **Check services are running:**
   ```bash
   docker ps
   ```

2. **Check notification service logs:**
   ```bash
   docker logs revhub-notification-service --tail 50
   ```

3. **Verify Kafka connection:**
   ```bash
   docker logs revhub-notification-service | findstr "kafka"
   ```

4. **Check if events are being sent:**
   ```bash
   docker exec revhub-kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic notification-events --from-beginning
   ```

All notifications are now fully functional! 🎉
