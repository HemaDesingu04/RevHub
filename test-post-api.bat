@echo off
echo Testing Post API...

echo.
echo 1. Testing with proper JSON formatting:
curl -s -X POST "http://localhost:8080/api/posts" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"content\":\"test post\",\"visibility\":\"FOLLOWERS_ONLY\"}" ^
  -w "HTTP Status: %%{http_code}"

echo.
echo.
echo 2. Testing with minimal required fields:
curl -s -X POST "http://localhost:8080/api/posts" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"content\":\"minimal test post\"}" ^
  -w "HTTP Status: %%{http_code}"

echo.
echo.
echo 3. Testing with public visibility:
curl -s -X POST "http://localhost:8080/api/posts" ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"content\":\"public test post\",\"visibility\":\"PUBLIC\"}" ^
  -w "HTTP Status: %%{http_code}"

echo.
echo.
echo 4. Getting all posts to verify:
curl -s "http://localhost:8080/api/posts" | jq .

pause