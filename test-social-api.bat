@echo off
echo Testing Social Service API Endpoints
echo =====================================
echo.

echo Testing followers endpoint for karthik_123:
curl -s http://localhost:8080/api/social/followers/karthik_123
echo.
echo.

echo Testing following endpoint for karthik_123:
curl -s http://localhost:8080/api/social/following/karthik_123
echo.
echo.

echo Done!
pause
