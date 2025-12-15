@echo off
echo ========================================
echo AWS Status Check for RevHub
echo ========================================

echo.
echo Checking Terraform state...
cd terraform

if not exist "terraform.tfstate" (
    echo ❌ No Terraform state found. Infrastructure not deployed.
    cd ..
    pause
    exit /b 1
)

echo.
echo Getting infrastructure status...
terraform output

echo.
echo Checking EC2 instance status...
for /f "tokens=*" %%i in ('terraform output -raw instance_id 2^>nul') do set INSTANCE_ID=%%i
for /f "tokens=*" %%i in ('terraform output -raw instance_public_ip 2^>nul') do set PUBLIC_IP=%%i

if defined INSTANCE_ID (
    echo Instance ID: %INSTANCE_ID%
    echo Public IP: %PUBLIC_IP%
    echo.
    
    echo Checking instance state...
    aws ec2 describe-instances --instance-ids %INSTANCE_ID% --query "Reservations[0].Instances[0].State.Name" --output text
    
    echo.
    echo Checking instance status...
    aws ec2 describe-instance-status --instance-ids %INSTANCE_ID% --query "InstanceStatuses[0].InstanceStatus.Status" --output text 2>nul
    
    echo.
    echo ========================================
    echo Access URLs:
    echo ========================================
    echo 🌐 Frontend: http://%PUBLIC_IP%:4200
    echo 🔧 API Gateway: http://%PUBLIC_IP%:8080
    echo 📊 Consul UI: http://%PUBLIC_IP%:8500
    echo 🔑 SSH Command: ssh -i revhub-key.pem ec2-user@%PUBLIC_IP%
    
    echo.
    echo Testing connectivity...
    ping -n 1 %PUBLIC_IP% >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ Instance is reachable
    ) else (
        echo ❌ Instance is not reachable
    )
) else (
    echo ❌ Could not get instance information
)

cd ..
echo.
pause