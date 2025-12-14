@echo off
echo ========================================
echo Testing Following Feed
echo ========================================
echo.

echo Waiting for post service to start...
timeout /t 30 /nobreak

echo.
echo ========================================
echo STEP-BY-STEP TEST
echo ========================================
echo.
echo 1. Open http://localhost:4200
echo 2. Create User A (e.g., alice)
echo 3. Login as alice
echo 4. Create a post with "Followers Only" visibility
echo 5. Logout
echo.
echo 6. Create User B (e.g., bob)
echo 7. Login as bob
echo 8. Go to alice's profile and click FOLLOW
echo 9. Click "Following Feed" button (👥)
echo 10. You should see alice's post!
echo.
echo ========================================
echo Debug Commands
echo ========================================
echo.
echo Check if bob follows alice:
echo   curl "http://localhost:8080/api/social/following/bob"
echo.
echo Check post service logs:
echo   docker logs revhub-post-service --tail 50
echo.
echo Look for these log lines:
echo   [FOLLOWING FEED] Getting feed for user: bob
echo   [FOLLOWING FEED] User bob follows: [alice]
echo   [FOLLOWING FEED] Including post from followed user alice
echo.
echo ========================================
echo.
pause

echo.
echo Checking if bob follows alice...
curl "http://localhost:8080/api/social/following/bob"

echo.
echo.
echo Checking post service logs...
docker logs revhub-post-service --tail 50 | findstr "FOLLOWING FEED"

echo.
pause
