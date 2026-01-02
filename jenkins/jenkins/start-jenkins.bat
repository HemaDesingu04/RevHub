@echo off
echo 🚀 Starting Jenkins...

if not exist .env (
    echo ❌ .env file not found. Please copy .env.example to .env and configure it.
    pause
    exit /b 1
)

cd docker
docker-compose up -d

echo ✅ Jenkins is starting up...
echo 📝 Access Jenkins at: http://localhost:8080
echo 👤 Default admin credentials: admin / admin123
echo.
echo ⏳ Waiting for Jenkins to be ready...

:wait_loop
if errorlevel 1 (
    echo    Still waiting...
    goto wait_loop
)

echo ✅ Jenkins is ready
echo.
echo 🔧 Next steps:
echo 1. Access Jenkins at http://localhost:8080
echo 2. Configure your GitHub repository
echo 3. Set up Docker registry credentials
echo 4. Run your first pipeline
pause
