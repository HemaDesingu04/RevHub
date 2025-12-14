# Quick Test Guide - Notifications

## ✅ System Status
- All services are running
- Kafka listener is active on `notification-events` topic
- Notification service is ready to receive events

## 🧪 Test Scenarios

### Test 1: Like Notification
1. **Login as User A** → Create a post
2. **Login as User B** → Like User A's post
3. **Login as User A** → Check notifications (should see "User B liked your post")

### Test 2: Comment Notification
1. **Login as User A** → Create a post
2. **Login as User B** → Comment on User A's post
3. **Login as User A** → Check notifications (should see "User B commented on your post")

### Test 3: Follow Notification
1. **Login as User A** → Note username
2. **Login as User B** → Follow User A
3. **Login as User A** → Check notifications (should see "User B started following you")

## 🔍 Monitoring Commands

### Watch Notifications in Real-Time
```bash
docker logs -f revhub-notification-service
```

### Check Kafka Events
```bash
docker exec -it revhub-kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic notification-events --from-beginning
```

### Get Notifications via API
```bash
# Replace 'username' with actual username
curl http://localhost:8080/api/notifications?userId=username
```

### Check Unread Count
```bash
curl http://localhost:8080/api/notifications/unread/count?userId=username
```

## 📍 Access Points
- **Frontend**: http://localhost:4200
- **Notifications Page**: http://localhost:4200/notifications
- **API Gateway**: http://localhost:8080
- **Notification Service**: http://localhost:8085

## ✨ What's Fixed
✅ Kafka configuration for proper event deserialization
✅ Self-notification prevention (no notifications for own actions)
✅ Enhanced logging for debugging
✅ Error handling for failed events
✅ All notification types: LIKE, COMMENT, FOLLOW, MESSAGE

## 🐛 If Issues Occur

### Check Service Health
```bash
curl http://localhost:8085/actuator/health
```

### View Recent Logs
```bash
docker logs revhub-notification-service --tail 100
```

### Verify Kafka Connection
```bash
docker logs revhub-notification-service | findstr "Kafka"
```

### Check MongoDB Connection
```bash
docker logs revhub-notification-service | findstr "MongoDB"
```

## 📝 Expected Log Output

When a notification is created, you should see:
```
INFO ... Received notification event: {type=LIKE, postAuthor=userA, likerUsername=userB, postId=123}
INFO ... Created LIKE notification for user: userA
```

## 🎯 Success Criteria
- [ ] User receives notification when someone likes their post
- [ ] User receives notification when someone comments on their post
- [ ] User receives notification when someone follows them
- [ ] User does NOT receive notification for their own actions
- [ ] Notifications appear in the UI at /notifications
- [ ] Unread count updates correctly

---

**Ready to Test!** 🚀

Start testing by opening http://localhost:4200 in your browser.
