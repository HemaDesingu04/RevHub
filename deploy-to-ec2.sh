#!/bin/bash
set -e

echo "=== RevHub AWS Deployment Script ==="

# Update system
sudo yum update -y

# Install Git if not present
sudo yum install -y git

# Navigate to app directory
cd /home/ec2-user/app

# Clone repository if not exists
if [ ! -d "revhub-microservices" ]; then
    git clone https://github.com/YOUR_USERNAME/revhub-microservices.git
fi

cd revhub-microservices

# Pull latest changes
git pull origin main

# Build shared modules
echo "Building shared modules..."
cd shared
mvn clean install -DskipTests

# Build all backend services
echo "Building backend services..."
cd ../backend-services

services=("api-gateway" "user-service" "post-service" "social-service" "chat-service" "notification-service" "feed-service" "search-service" "saga-orchestrator")

for service in "${services[@]}"; do
    if [ -d "$service" ]; then
        echo "Building $service..."
        cd "$service"
        mvn clean package -DskipTests
        cd ..
    fi
done

# Start Docker services
echo "Starting Docker services..."
cd ..
sudo docker-compose down || true
sudo docker-compose up -d --build

# Wait for services to start
echo "Waiting for services to start..."
sleep 120

# Health check
echo "Performing health check..."
if curl -f http://localhost:8080/actuator/health; then
    echo "✅ Deployment successful!"
    echo "🌐 Frontend: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):4200"
    echo "🔧 API Gateway: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
else
    echo "❌ Deployment failed"
    exit 1
fi

echo "=== Deployment completed! ==="