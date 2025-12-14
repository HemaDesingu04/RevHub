@echo off
echo ========================================
echo Testing Micro-Frontend Architecture
echo ========================================
echo.

echo Checking if micro-frontends are exposing remoteEntry.js...
echo.

echo [1/5] Testing Auth Micro-frontend (4201)...
curl -s -o nul -w "Status: %%{http_code}\n" http://localhost:4201/remoteEntry.js
echo.

echo [2/5] Testing Feed Micro-frontend (4202)...
curl -s -o nul -w "Status: %%{http_code}\n" http://localhost:4202/remoteEntry.js
echo.

echo [3/5] Testing Profile Micro-frontend (4203)...
curl -s -o nul -w "Status: %%{http_code}\n" http://localhost:4203/remoteEntry.js
echo.

echo [4/5] Testing Chat Micro-frontend (4204)...
curl -s -o nul -w "Status: %%{http_code}\n" http://localhost:4204/remoteEntry.js
echo.

echo [5/5] Testing Notifications Micro-frontend (4205)...
curl -s -o nul -w "Status: %%{http_code}\n" http://localhost:4205/remoteEntry.js
echo.

echo ========================================
echo Testing Shell App (4200)...
curl -s -o nul -w "Status: %%{http_code}\n" http://localhost:4200
echo.

echo ========================================
echo If all show "Status: 200", micro-frontends are working!
echo ========================================
pause
