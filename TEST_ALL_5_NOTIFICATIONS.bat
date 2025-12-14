@echo off
echo ========================================
echo Testing All 5 Notification Types
echo ========================================
echo.

echo Waiting for services to be fully ready...
timeout /t 20 /nobreak

echo.
echo ========================================
echo Service Status
echo ========================================
docker ps --format "table {{.Names}}\t{{.Status}}" | findstr "notification-service post-service chat-service social-service"

echo.
echo ========================================
echo Kafka Listener Status
echo ========================================
docker logs revhub-notification-service 2>&1 | findstr "partitions assigned"

echo.
echo ========================================
echo TEST SCENARIOS
echo ========================================
echo.
echo Open http://localhost:4200 in your browser
echo.
echo Create TWO users for testing:
echo   - User A (e.g., alice)
echo   - User B (e.g., bob)
echo.
echo ----------------------------------------
echo Test 1: LIKE Notification
echo ----------------------------------------
echo 1. Login as User A
echo 2. Create a post
echo 3. Logout and login as User B
echo 4. Like User A's post
echo 5. Logout and login as User A
echo 6. Check notifications - should see "bob liked your post"
echo.
echo ----------------------------------------
echo Test 2: COMMENT Notification
echo ----------------------------------------
echo 1. Login as User A (if not already)
echo 2. Find your post
echo 3. Logout and login as User B
echo 4. Comment on User A's post
echo 5. Logout and login as User A
echo 6. Check notifications - should see "bob commented on your post"
echo.
echo ----------------------------------------
echo Test 3: FOLLOW Notification
echo ----------------------------------------
echo 1. Login as User B
echo 2. Go to User A's profile
echo 3. Click Follow button
echo 4. Logout and login as User A
echo 5. Check notifications - should see "bob started following you"
echo.
echo ----------------------------------------
echo Test 4: MESSAGE Notification
echo ----------------------------------------
echo 1. Login as User B
echo 2. Go to Chat page
echo 3. Send message to User A
echo 4. Logout and login as User A
echo 5. Check notifications - should see "bob sent you a message"
echo.
echo ----------------------------------------
echo Test 5: MENTION Notification
echo ----------------------------------------
echo 1. Login as User B
echo 2. Create a new post with text: "Hey @alice check this out!"
echo 3. Logout and login as User A
echo 4. Check notifications - should see "bob mentioned you in a post"
echo.
echo ----------------------------------------
echo BONUS: Mention in Comment
echo ----------------------------------------
echo 1. Login as User B
echo 2. Comment on any post with: "@alice great post!"
echo 3. Logout and login as User A
echo 4. Check notifications - should see BOTH:
echo    - "bob commented on your post"
echo    - "bob mentioned you in a post"
echo.
echo ========================================
echo Monitoring Commands
echo ========================================
echo.
echo Watch notifications in real-time:
echo   docker logs -f revhub-notification-service
echo.
echo Monitor Kafka events:
echo   docker exec -it revhub-kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic notification-events --from-beginning
echo.
echo Check notifications via API:
echo   curl "http://localhost:8080/api/notifications?userId=alice"
echo.
echo ========================================
echo.
pause
