@echo off
echo ========================================
echo    RevHub SSH Access Setup
echo ========================================

set REGION=ap-south-1
set KEY_NAME=RevHub-KeyPair

echo.
echo Step 1: Creating EC2 Key Pair...
aws ec2 create-key-pair --key-name %KEY_NAME% --query "KeyMaterial" --output text --region %REGION% > %KEY_NAME%.pem

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to create key pair. It might already exist.
    echo You can download it from AWS Console: EC2 → Key Pairs
    pause
    exit /b 1
)

echo Key pair created successfully: %KEY_NAME%.pem
echo.

echo Step 2: Getting your public IP for security group...
for /f "tokens=*" %%i in ('curl -s https://checkip.amazonaws.com') do set MY_IP=%%i
echo Your public IP: %MY_IP%

echo.
echo Step 3: Security recommendations...
echo.
echo IMPORTANT SECURITY NOTES:
echo 1. Keep %KEY_NAME%.pem file secure and private
echo 2. Never share or commit this file to version control
echo 3. Restrict SSH access to your IP only: %MY_IP%/32
echo 4. Use AWS Session Manager for production environments
echo.

echo Step 4: How to connect to EC2 instances...
echo.
echo After deployment, find your instance IP:
echo   aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=RevHub-ASG" --query "Reservations[].Instances[].PublicIpAddress" --output text --region %REGION%
echo.
echo Then connect using:
echo   ssh -i %KEY_NAME%.pem ec2-user@^<INSTANCE-IP^>
echo.

echo Step 5: Useful commands after SSH...
echo.
echo # Check ECS agent status
echo   sudo docker ps
echo   sudo service ecs status
echo.
echo # View ECS logs
echo   sudo docker logs ecs-agent
echo.
echo # Check running containers
echo   sudo docker ps
echo.
echo # View container logs
echo   sudo docker logs ^<container-id^>
echo.

echo ========================================
echo    SSH Setup Complete!
echo ========================================
echo.
echo Next: Run deploy-to-aws.bat to deploy infrastructure
echo.
pause