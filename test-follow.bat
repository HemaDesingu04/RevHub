@echo off
echo Testing Follow Functionality...
echo.
echo This should now return 200 OK instead of 500 error
echo The follow will be saved to database and Kafka events will be sent asynchronously
echo.
curl -X POST "http://localhost:8080/api/social/follow/testuser?follower=currentuser" -H "Content-Type: application/json"
echo.
echo.
echo If you see a follow object returned above, the fix is working!
pause
