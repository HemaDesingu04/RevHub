# 🚀 AWS Deployment Guide - RevHub Microservices

Complete guide to deploy RevHub microservices platform on AWS using EC2, Docker, and CI/CD.

## 📋 Prerequisites

- AWS Account with appropriate permissions
- GitHub account
- Local machine with Git, AWS CLI, and Terraform installed
- Domain name (optional, for custom URLs)

## 🏗️ Architecture Overview

```
GitHub → GitHub Actions → AWS EC2 → Docker Containers
├── Frontend (Angular) - Port 4200
├── API Gateway - Port 8080
├── 9 Microservices - Ports 8081-8088
├── Infrastructure (Consul, Kafka, MySQL, MongoDB)
└── Elastic IP for public access
```

---

## Step 1: GitHub Repository Setup

### 1.1 Create GitHub Repository
```bash
# Initialize local repository
git init
git add .
git commit -m "RevHub microservices initial commit"

# Create repository on GitHub (revhub-microservices)
git remote add origin https://github.com/YOUR_USERNAME/revhub-microservices.git
git branch -M main
git push -u origin main
```

---

## Step 2: AWS Prerequisites

### 2.1 Install AWS CLI
```bash
# Windows
curl "https://awscli.amazonaws.com/AWSCLIV2.msi" -o "AWSCLIV2.msi"
msiexec /i AWSCLIV2.msi

# Verify installation
aws --version
```

### 2.2 Configure AWS CLI
```bash
aws configure
# AWS Access Key ID: [Your Access Key]
# AWS Secret Access Key: [Your Secret Key]
# Default region name: us-east-1
# Default output format: json
```

### 2.3 Create EC2 Key Pair
```bash
# Create key pair
aws ec2 create-key-pair --key-name revhub-key --query 'KeyMaterial' --output text > revhub-key.pem

# Set permissions (Linux/Mac)
chmod 400 revhub-key.pem

# Windows - Set file permissions via Properties > Security
```

---

## Step 3: Terraform Infrastructure

### 3.1 Create Terraform Configuration

Create `terraform/` directory with the following files:

**variables.tf**
```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "revhub-key"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "revhub"
}
```

**main.tf**
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "revhub_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "revhub_igw" {
  vpc_id = aws_vpc.revhub_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "revhub_public_subnet" {
  vpc_id                  = aws_vpc.revhub_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "revhub_public_rt" {
  vpc_id = aws_vpc.revhub_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.revhub_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "revhub_public_rta" {
  subnet_id      = aws_subnet.revhub_public_subnet.id
  route_table_id = aws_route_table.revhub_public_rt.id
}

# Security Group
resource "aws_security_group" "revhub_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for RevHub application"
  vpc_id      = aws_vpc.revhub_vpc.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend
  ingress {
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # API Gateway
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Microservices
  ingress {
    from_port   = 8081
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Consul
  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# EC2 Instance
resource "aws_instance" "revhub_instance" {
  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2023
  instance_type          = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [aws_security_group.revhub_sg.id]
  subnet_id             = aws_subnet.revhub_public_subnet.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 30
    encrypted   = true
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {}))

  tags = {
    Name = "${var.project_name}-instance"
  }
}

# Elastic IP
resource "aws_eip" "revhub_eip" {
  instance = aws_instance.revhub_instance.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}
```

**outputs.tf**
```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.revhub_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.revhub_eip.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.revhub_instance.public_dns
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i revhub-key.pem ec2-user@${aws_eip.revhub_eip.public_ip}"
}
```

**user-data.sh**
```bash
#!/bin/bash
yum update -y

# Install Git
yum install -y git

# Install Java 17
yum install -y java-17-amazon-corretto-devel

# Install Maven
cd /opt
wget https://archive.apache.org/dist/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
tar xzf apache-maven-3.9.4-bin.tar.gz
ln -s apache-maven-3.9.4 maven
echo 'export PATH=/opt/maven/bin:$PATH' >> /etc/profile
source /etc/profile

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Install Node.js and npm
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Create application directory
mkdir -p /home/ec2-user/app
chown ec2-user:ec2-user /home/ec2-user/app
```

### 3.2 Deploy Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

---

## Step 4: EC2 Instance Setup

### 4.1 Connect to EC2
```bash
# Get the public IP from Terraform output
terraform output instance_public_ip

# SSH to instance
ssh -i revhub-key.pem ec2-user@YOUR_ELASTIC_IP
```

### 4.2 Verify Installation
```bash
# Check installations
java -version
mvn -version
docker --version
docker-compose --version
node --version
npm --version
```

---

## Step 5: Application Deployment

### 5.1 Clone Repository
```bash
cd /home/ec2-user/app
git clone https://github.com/YOUR_USERNAME/revhub-microservices.git
cd revhub-microservices
```

### 5.2 Build and Deploy
```bash
# Make scripts executable
chmod +x scripts/*.bat

# Build shared modules
cd shared
mvn clean install -DskipTests

# Build all services
cd ../scripts
./build-all-services.bat

# Start with Docker
./START_DOCKER.bat
```

---

## Step 6: Database Configuration

### 6.1 Initialize Databases
```bash
# Wait for containers to start
sleep 60

# Check container status
docker-compose ps

# Initialize MySQL
docker exec -it revhub-mysql mysql -uroot -proot -e "
CREATE DATABASE IF NOT EXISTS revhub;
USE revhub;
-- Tables will be created automatically by JPA
"

# Initialize MongoDB
docker exec -it revhub-mongodb mongosh -u root -p root --authenticationDatabase admin --eval "
use revhub;
db.createCollection('posts');
db.createCollection('messages');
db.createCollection('notifications');
db.createCollection('feed_items');
"
```

---

## Step 7: Frontend Deployment

### 7.1 Build Frontend Applications
```bash
# Install dependencies and build all frontends
cd frontend-services

# Shell App
cd shell-app
npm install
npm run build
cd ..

# Auth Microfrontend
cd auth-microfrontend
npm install
npm run build
cd ..

# Repeat for all microfrontends...
```

### 7.2 Start Frontend Services
```bash
# Start all frontend services
cd ../scripts
./start-all-frontends.bat
```

---

## Step 8: CI/CD with GitHub Actions

### 8.1 Create GitHub Secrets

Go to GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `EC2_HOST`: Your Elastic IP address
- `EC2_PRIVATE_KEY`: Contents of revhub-key.pem file
- `EC2_USER`: ec2-user

### 8.2 Create Deployment Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to AWS EC2

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Setup SSH
      run: |
        mkdir -p ~/.ssh
        echo "${{ secrets.EC2_PRIVATE_KEY }}" > ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        ssh-keyscan -H ${{ secrets.EC2_HOST }} >> ~/.ssh/known_hosts
        
    - name: Deploy to EC2
      run: |
        ssh -i ~/.ssh/id_rsa ${{ secrets.EC2_USER }}@${{ secrets.EC2_HOST }} << 'EOF'
          cd /home/ec2-user/app/revhub-microservices
          
          # Pull latest changes
          git pull origin main
          
          # Stop existing services
          docker-compose down
          
          # Build shared modules
          cd shared
          mvn clean install -DskipTests
          
          # Build all services
          cd ../backend-services
          for service in */; do
            if [ -d "$service" ]; then
              echo "Building $service"
              cd "$service"
              mvn clean package -DskipTests
              cd ..
            fi
          done
          
          # Start services
          cd ..
          docker-compose up -d --build
          
          # Wait for services to start
          sleep 60
          
          # Health check
          curl -f http://localhost:8080/actuator/health || exit 1
          
          echo "Deployment completed successfully!"
        EOF
```

---

## Step 9: Testing Deployment

### 9.1 Access Application
```bash
# Frontend
http://YOUR_ELASTIC_IP:4200

# API Gateway
http://YOUR_ELASTIC_IP:8080

# Consul UI
http://YOUR_ELASTIC_IP:8500

# Individual services
http://YOUR_ELASTIC_IP:8081  # User Service
http://YOUR_ELASTIC_IP:8082  # Post Service
# ... etc
```

### 9.2 Health Checks
```bash
# Check all services
curl http://YOUR_ELASTIC_IP:8080/actuator/health
curl http://YOUR_ELASTIC_IP:8081/actuator/health
curl http://YOUR_ELASTIC_IP:8082/actuator/health
# ... check all services

# Check Docker containers
ssh -i revhub-key.pem ec2-user@YOUR_ELASTIC_IP
docker ps
docker-compose logs -f
```

### 9.3 Test CI/CD
```bash
# Make a small change and push
echo "# Test deployment" >> README.md
git add .
git commit -m "Test CI/CD deployment"
git push origin main

# Check GitHub Actions tab for deployment status
```

---

## Step 10: Monitoring & Maintenance

### 10.1 Monitoring Commands
```bash
# SSH to instance
ssh -i revhub-key.pem ec2-user@YOUR_ELASTIC_IP

# Check system resources
htop
df -h
free -m

# Check Docker containers
docker ps
docker stats

# Check service logs
docker-compose logs -f api-gateway
docker-compose logs -f user-service

# Check application logs
tail -f /var/log/messages
```

### 10.2 Maintenance Tasks
```bash
# Update system packages
sudo yum update -y

# Clean Docker resources
docker system prune -f
docker volume prune -f

# Restart services
docker-compose restart

# Full restart
docker-compose down
docker-compose up -d
```

### 10.3 Backup Strategy
```bash
# Backup databases
docker exec revhub-mysql mysqldump -uroot -proot revhub > backup-mysql-$(date +%Y%m%d).sql
docker exec revhub-mongodb mongodump --uri="mongodb://root:root@localhost:27017/revhub?authSource=admin" --out=/backup/mongodb-$(date +%Y%m%d)

# Backup application code
tar -czf revhub-backup-$(date +%Y%m%d).tar.gz /home/ec2-user/app/revhub-microservices
```

---

## 🔧 Troubleshooting

### Common Issues

**Port Already in Use**
```bash
sudo netstat -tlnp | grep :8080
sudo kill -9 PID
```

**Docker Permission Denied**
```bash
sudo usermod -a -G docker ec2-user
newgrp docker
```

**Service Not Starting**
```bash
docker-compose logs -f SERVICE_NAME
docker-compose restart SERVICE_NAME
```

**Database Connection Issues**
```bash
# Check MySQL
docker exec -it revhub-mysql mysql -uroot -proot -e "SHOW DATABASES;"

# Check MongoDB
docker exec -it revhub-mongodb mongosh -u root -p root --authenticationDatabase admin
```

---

## 💰 Cost Optimization

### Instance Sizing
- **Development**: t3.medium ($30/month)
- **Production**: t3.large ($60/month)
- **High Traffic**: t3.xlarge ($120/month)

### Cost Saving Tips
1. Use Spot Instances for development (50-70% savings)
2. Schedule instance stop/start for non-production
3. Use Application Load Balancer for high availability
4. Implement auto-scaling for traffic spikes

---

## 🚀 Production Enhancements

### Security
- Use AWS Secrets Manager for database passwords
- Enable CloudTrail for audit logging
- Configure WAF for web application firewall
- Use VPC endpoints for private communication

### High Availability
- Deploy across multiple AZs
- Use RDS for managed databases
- Implement Application Load Balancer
- Use Auto Scaling Groups

### Monitoring
- CloudWatch for metrics and logs
- X-Ray for distributed tracing
- SNS for alerting
- ELK stack for log analysis

---

## 📊 Success Metrics

✅ Infrastructure deployed with Terraform
✅ EC2 instance configured and running
✅ All 9 microservices containerized
✅ Databases initialized and connected
✅ Frontend applications accessible
✅ CI/CD pipeline working
✅ Health checks passing
✅ Elastic IP configured
✅ Monitoring in place

## 🎯 Next Steps

1. **Custom Domain**: Configure Route 53 for custom domain
2. **SSL Certificate**: Add HTTPS with ACM
3. **Load Balancer**: Implement ALB for high availability
4. **Auto Scaling**: Configure auto scaling groups
5. **Monitoring**: Set up CloudWatch dashboards
6. **Backup**: Implement automated backup strategy

---

**🚀 Your RevHub microservices platform is now running on AWS!**

Access your application at: `http://YOUR_ELASTIC_IP:4200`