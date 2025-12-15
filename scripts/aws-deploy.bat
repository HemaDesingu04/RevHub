@echo off
echo ========================================
echo AWS Deployment Script for RevHub
echo ========================================

echo.
echo Step 1: Checking prerequisites...

aws --version >nul 2>&1
if %errorlevel% neq 0 (
    echo AWS CLI not found. Please install AWS CLI first.
    echo Download from: https://aws.amazon.com/cli/
    pause
    exit /b 1
)
echo AWS CLI found

terraform version >nul 2>&1
if %errorlevel% neq 0 (
    echo Terraform not found. Please install Terraform first.
    echo Download from: https://www.terraform.io/downloads.html
    pause
    exit /b 1
)
echo Terraform found

git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Git not found. Please install Git first.
    echo Download from: https://git-scm.com/downloads
    pause
    exit /b 1
)
echo Git found

echo.
echo Step 2: AWS Configuration Check...
aws sts get-caller-identity >nul 2>&1
if %errorlevel% neq 0 (
    echo AWS not configured. Please run: aws configure
    pause
    exit /b 1
)
echo AWS credentials configured

echo.
echo Step 3: Creating EC2 Key Pair...
if not exist "revhub-key.pem" (
    echo Creating new key pair...
    aws ec2 create-key-pair --key-name revhub-key --query "KeyMaterial" --output text > revhub-key.pem
    if %errorlevel% neq 0 (
        echo Failed to create key pair
        pause
        exit /b 1
    )
    echo Key pair created: revhub-key.pem
) else (
    echo Key pair already exists: revhub-key.pem
)

echo.
echo Step 4: Preparing Terraform configuration...
cd terraform

if not exist "terraform.tfvars" (
    echo Creating terraform.tfvars from example...
    copy terraform.tfvars.example terraform.tfvars
    echo Please edit terraform.tfvars to customize your deployment
    pause
)

echo.
echo Step 5: Deploying infrastructure with Terraform...
echo Initializing Terraform...
terraform init
if %errorlevel% neq 0 (
    echo Terraform init failed
    pause
    exit /b 1
)

echo.
echo Planning deployment...
terraform plan
if %errorlevel% neq 0 (
    echo Terraform plan failed
    pause
    exit /b 1
)

echo.
echo Applying infrastructure...
terraform apply -auto-approve
if %errorlevel% neq 0 (
    echo Terraform apply failed
    pause
    exit /b 1
)

echo.
echo Step 6: Getting deployment information...
echo ========================================
echo Infrastructure deployed successfully!
echo ========================================
terraform output

echo.
echo Step 7: Next steps...
echo 1. Wait 5-10 minutes for EC2 instance to fully initialize
echo 2. SSH to your instance using the command shown above
echo 3. Clone your repository and run the deployment
echo 4. Set up GitHub Actions secrets for CI/CD
echo.
echo For detailed instructions, see AWS_DEPLOYMENT.md

cd ..
pause