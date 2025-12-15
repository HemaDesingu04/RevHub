@echo off
echo ========================================
echo AWS Cleanup Script for RevHub
echo ========================================

echo.
echo ⚠️ WARNING: This will destroy ALL AWS resources created by Terraform
echo This action cannot be undone!
echo.

set /p confirm="Are you sure you want to destroy all resources? (yes/no): "
if /i not "%confirm%"=="yes" (
    echo Cleanup cancelled.
    pause
    exit /b 0
)

echo.
echo Step 1: Destroying infrastructure with Terraform...
cd terraform

terraform destroy -auto-approve
if %errorlevel% neq 0 (
    echo ❌ Terraform destroy failed
    echo Some resources might still exist. Check AWS console.
    pause
    exit /b 1
)

echo.
echo Step 2: Cleaning up local files...
cd ..

if exist "revhub-key.pem" (
    echo Removing local key pair file...
    del revhub-key.pem
)

echo.
echo Step 3: Removing AWS key pair...
aws ec2 delete-key-pair --key-name revhub-key
if %errorlevel% neq 0 (
    echo ⚠️ Failed to delete key pair from AWS (might not exist)
)

echo.
echo ========================================
echo 🧹 Cleanup completed successfully!
echo ========================================
echo All AWS resources have been destroyed.
echo Your local code remains unchanged.

pause