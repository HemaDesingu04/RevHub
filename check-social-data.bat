@echo off
echo Checking Social Service Data for karthik_123
echo =============================================
echo.

echo Testing API Gateway route to Social Service:
curl -s http://localhost:8080/api/social/followers/karthik_123
echo.
echo.

echo Testing direct Social Service:
curl -s http://localhost:8083/api/social/followers/karthik_123
echo.
echo.

echo Testing following:
curl -s http://localhost:8080/api/social/following/karthik_123
echo.
echo.

pause
