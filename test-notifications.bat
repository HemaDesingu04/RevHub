@echo off
echo ========================================
echo Testing Notification System
echo ========================================
echo.

echo Waiting for services to be ready...
timeout /t 30 /nobreak

echo.
echo Checking notification service logs for Kafka listener...
docker logs revhub-notification-service --tail 50 | findstr /C:"Started" /C:"Kafka" /C:"notification"

echo.
echo ========================================
echo Test Instructions:
echo ========================================
echo 1. Open http://localhost:4200 in your browser
echo 2. Login with two different users (User A and User B)
echo 3. As User A, create a post
echo 4. As User B, like the post (User A should get notification)
echo 5. As User B, comment on the post (User A should get notification)
echo 6. As User B, follow User A (User A should get notification)
echo 7. Check notifications at http://localhost:4200/notifications
echo.
echo To monitor notifications in real-time:
echo   docker logs -f revhub-notification-service
echo.
echo To check Kafka topics:
echo   docker exec -it revhub-kafka kafka-console-consumer --bootstrap-server localhost:9092 --topic notification-events --from-beginning
echo.
pause
