@echo off
echo ========================================
echo    RevHub AWS ECS Deployment Script
echo ========================================

REM Set variables
set STACK_NAME=RevHub-Infrastructure
set REGION=ap-south-1
set KEY_PAIR_NAME=RevHub-KeyPair
set AWS_ACCOUNT_ID=026090556302

echo.
echo Step 1: Creating AWS Infrastructure...
aws cloudformation create-stack ^
    --stack-name %STACK_NAME% ^
    --template-body file://aws-ecs-infrastructure.yml ^
    --parameters ParameterKey=KeyPairName,ParameterValue=%KEY_PAIR_NAME% ^
    --capabilities CAPABILITY_IAM ^
    --region %REGION%

echo.
echo Waiting for infrastructure stack to complete...
aws cloudformation wait stack-create-complete ^
    --stack-name %STACK_NAME% ^
    --region %REGION%

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Infrastructure stack creation failed!
    exit /b 1
)

echo.
echo Step 2: Getting stack outputs...
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name %STACK_NAME% --query "Stacks[0].Outputs[?OutputKey=='LoadBalancerURL'].OutputValue" --output text --region %REGION%') do set ALB_URL=%%i
for /f "tokens=*" %%i in ('aws cloudformation describe-stacks --stack-name %STACK_NAME% --query "Stacks[0].Outputs[?OutputKey=='DatabaseEndpoint'].OutputValue" --output text --region %REGION%') do set DB_ENDPOINT=%%i

echo.
echo Step 3: Building and pushing Docker images to ECR...
REM Get ECR login
aws ecr get-login-password --region %REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com

REM Build and push images
docker build -t revhub/api-gateway backend-services/api-gateway
docker tag revhub/api-gateway:latest %AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/revhub/api-gateway:latest
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/revhub/api-gateway:latest

docker build -t revhub/user-service backend-services/user-service
docker tag revhub/user-service:latest %AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/revhub/user-service:latest
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/revhub/user-service:latest

docker build -t revhub/post-service backend-services/post-service
docker tag revhub/post-service:latest %AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/revhub/post-service:latest
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com/revhub/post-service:latest

echo.
echo Step 4: Deploying ECS services...
aws cloudformation create-stack ^
    --stack-name RevHub-Services ^
    --template-body file://ecs-task-definitions.yml ^
    --parameters ParameterKey=ECRRegistry,ParameterValue=%AWS_ACCOUNT_ID%.dkr.ecr.%REGION%.amazonaws.com ^
                 ParameterKey=DatabaseEndpoint,ParameterValue=%DB_ENDPOINT% ^
    --capabilities CAPABILITY_IAM ^
    --region %REGION%

echo.
echo Waiting for services stack to complete...
aws cloudformation wait stack-create-complete ^
    --stack-name RevHub-Services ^
    --region %REGION%

echo.
echo ========================================
echo    Deployment Complete!
echo ========================================
echo.
echo Application URL: %ALB_URL%
echo Database Endpoint: %DB_ENDPOINT%
echo.
echo Next steps:
echo 1. Update DNS records to point to the Load Balancer
echo 2. Configure SSL certificate
echo 3. Set up monitoring and alerts
echo.
pause