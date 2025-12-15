#!/bin/bash

# Update system
yum update -y

# Install Git
yum install -y git

# Install Java 17
yum install -y java-17-amazon-corretto-devel

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> /etc/profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile

# Install Maven
cd /opt
wget https://archive.apache.org/dist/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
tar xzf apache-maven-3.9.4-bin.tar.gz
ln -s apache-maven-3.9.4 maven
echo 'export M2_HOME=/opt/maven' >> /etc/profile
echo 'export PATH=/opt/maven/bin:$PATH' >> /etc/profile

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Install Node.js 18 and npm
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install Angular CLI globally
npm install -g @angular/cli

# Install htop for monitoring
yum install -y htop

# Create application directory
mkdir -p /home/ec2-user/app
chown ec2-user:ec2-user /home/ec2-user/app

# Create logs directory
mkdir -p /var/log/revhub
chown ec2-user:ec2-user /var/log/revhub

# Set up environment variables
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> /home/ec2-user/.bashrc
echo 'export M2_HOME=/opt/maven' >> /home/ec2-user/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH' >> /home/ec2-user/.bashrc

# Source the profile
source /etc/profile

# Create a simple health check script
cat > /home/ec2-user/health-check.sh << 'EOF'
#!/bin/bash
echo "=== RevHub Health Check ==="
echo "Date: $(date)"
echo ""

echo "=== System Resources ==="
echo "Memory Usage:"
free -h
echo ""
echo "Disk Usage:"
df -h
echo ""

echo "=== Docker Status ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo "=== Service Health Checks ==="
services=("8080" "8081" "8082" "8083" "8084" "8085" "8086" "8087" "8088")
for port in "${services[@]}"; do
    if curl -s -f "http://localhost:$port/actuator/health" > /dev/null 2>&1; then
        echo "Service on port $port: HEALTHY"
    else
        echo "Service on port $port: UNHEALTHY"
    fi
done
EOF

chmod +x /home/ec2-user/health-check.sh
chown ec2-user:ec2-user /home/ec2-user/health-check.sh

# Create deployment script
cat > /home/ec2-user/deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "=== Starting RevHub Deployment ==="
cd /home/ec2-user/app/revhub-microservices

# Pull latest changes
echo "Pulling latest changes..."
git pull origin main

# Stop existing services
echo "Stopping existing services..."
docker-compose down

# Build shared modules
echo "Building shared modules..."
cd shared
mvn clean install -DskipTests

# Build all services
echo "Building backend services..."
cd ../backend-services
for service in */; do
    if [ -d "$service" ] && [ -f "$service/pom.xml" ]; then
        echo "Building $service"
        cd "$service"
        mvn clean package -DskipTests
        cd ..
    fi
done

# Start services
echo "Starting services with Docker..."
cd ..
docker-compose up -d --build

# Wait for services to start
echo "Waiting for services to start..."
sleep 90

# Health check
echo "Performing health check..."
if curl -f http://localhost:8080/actuator/health; then
    echo "Deployment successful!"
else
    echo "Deployment failed - API Gateway not responding"
    exit 1
fi

echo "=== Deployment completed successfully! ==="
EOF

chmod +x /home/ec2-user/deploy.sh
chown ec2-user:ec2-user /home/ec2-user/deploy.sh

# Log the completion
echo "User data script completed at $(date)" >> /var/log/user-data.log