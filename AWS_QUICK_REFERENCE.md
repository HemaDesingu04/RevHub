# 🚀 AWS Quick Reference - RevHub

## 📋 Quick Commands

### 🏗️ Initial Deployment
```bash
# 1. Run automated deployment
scripts\aws-deploy.bat

# 2. Get instance IP
cd terraform
terraform output instance_public_ip

# 3. SSH to instance
ssh -i revhub-key.pem ec2-user@YOUR_IP

# 4. Clone and deploy
cd /home/ec2-user/app
git clone https://github.com/YOUR_USERNAME/revhub-microservices.git
cd revhub-microservices
./deploy.sh
```

### 📊 Status & Monitoring
```bash
# Check AWS resources
scripts\aws-status.bat

# SSH to instance
ssh -i revhub-key.pem ec2-user@YOUR_IP

# Check services on EC2
./health-check.sh
docker-compose ps
docker-compose logs -f
```

### 🔄 Updates & Deployment
```bash
# Local changes → GitHub → Auto deploy
git add .
git commit -m "Update"
git push origin main

# Manual deployment on EC2
ssh -i revhub-key.pem ec2-user@YOUR_IP
cd /home/ec2-user/app/revhub-microservices
./deploy.sh
```

### 🧹 Cleanup
```bash
# Destroy all AWS resources
scripts\aws-cleanup.bat
```

---

## 🌐 Access URLs

Replace `YOUR_IP` with your Elastic IP:

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | `http://YOUR_IP:4200` | Main application |
| **API Gateway** | `http://YOUR_IP:8080` | Backend API |
| **Consul UI** | `http://YOUR_IP:8500` | Service registry |
| **User Service** | `http://YOUR_IP:8081/actuator/health` | Health check |
| **Post Service** | `http://YOUR_IP:8082/actuator/health` | Health check |
| **Social Service** | `http://YOUR_IP:8083/actuator/health` | Health check |
| **Chat Service** | `http://YOUR_IP:8084/actuator/health` | Health check |
| **Notification** | `http://YOUR_IP:8085/actuator/health` | Health check |
| **Feed Service** | `http://YOUR_IP:8086/actuator/health` | Health check |
| **Search Service** | `http://YOUR_IP:8087/actuator/health` | Health check |
| **Saga Service** | `http://YOUR_IP:8088/actuator/health` | Health check |

---

## 🔧 Troubleshooting

### Service Not Starting
```bash
# Check logs
docker-compose logs -f SERVICE_NAME

# Restart service
docker-compose restart SERVICE_NAME

# Rebuild service
cd backend-services/SERVICE_NAME
mvn clean package -DskipTests
cd ../..
docker-compose up -d --build SERVICE_NAME
```

### Database Issues
```bash
# Check MySQL
docker exec -it revhub-mysql mysql -uroot -proot -e "SHOW DATABASES;"

# Check MongoDB
docker exec -it revhub-mongodb mongosh -u root -p root --authenticationDatabase admin
```

### Port Issues
```bash
# Check what's using a port
sudo netstat -tlnp | grep :8080

# Kill process
sudo kill -9 PID
```

### Docker Issues
```bash
# Clean restart
docker-compose down -v
docker system prune -f
docker-compose up -d --build
```

### Frontend Not Loading
```bash
# Check if backend is running
curl http://localhost:8080/actuator/health

# Start frontend manually
cd frontend-services/shell-app
npm install
npm start
```

---

## 📊 Monitoring Commands

### System Resources
```bash
# CPU and Memory
htop

# Disk usage
df -h

# Memory usage
free -m

# Docker stats
docker stats
```

### Service Health
```bash
# All services health check
./health-check.sh

# Individual service
curl http://localhost:8081/actuator/health

# Service logs
docker-compose logs -f user-service
```

### Database Status
```bash
# MySQL status
docker exec revhub-mysql mysqladmin -uroot -proot status

# MongoDB status
docker exec revhub-mongodb mongosh -u root -p root --authenticationDatabase admin --eval "db.adminCommand('serverStatus')"
```

---

## 🔐 GitHub Secrets Setup

Go to GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `EC2_HOST`: Your Elastic IP (get from `terraform output`)
- `EC2_USER`: `ec2-user`
- `EC2_PRIVATE_KEY`: Contents of `revhub-key.pem` file

---

## 💰 Cost Estimates

### Instance Types (Monthly)
- **t3.medium**: ~$30 (Development)
- **t3.large**: ~$60 (Production)
- **t3.xlarge**: ~$120 (High traffic)

### Additional Costs
- **Elastic IP**: $3.65/month (if not attached to running instance)
- **EBS Storage**: $3/month (30GB)
- **Data Transfer**: $0.09/GB (outbound)

### Cost Optimization
```bash
# Stop instance when not needed
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# Start instance
aws ec2 start-instances --instance-ids i-1234567890abcdef0

# Use Spot instances for development (50-70% savings)
```

---

## 🚀 Production Checklist

### Security
- [ ] Restrict security group to specific IPs
- [ ] Use AWS Secrets Manager for passwords
- [ ] Enable CloudTrail logging
- [ ] Configure WAF

### High Availability
- [ ] Deploy across multiple AZs
- [ ] Use Application Load Balancer
- [ ] Set up Auto Scaling Groups
- [ ] Use RDS for databases

### Monitoring
- [ ] Set up CloudWatch dashboards
- [ ] Configure SNS alerts
- [ ] Enable X-Ray tracing
- [ ] Set up log aggregation

### Backup
- [ ] Automated EBS snapshots
- [ ] Database backups
- [ ] Application code backups

---

## 📞 Support Commands

### Get Help
```bash
# Terraform help
terraform -help

# AWS CLI help
aws help

# Docker help
docker --help
docker-compose --help
```

### Useful AWS CLI Commands
```bash
# List EC2 instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' --output table

# List security groups
aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId,GroupName]' --output table

# Check billing
aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-31 --granularity MONTHLY --metrics BlendedCost
```

---

## 🎯 Success Indicators

✅ Terraform applies without errors
✅ EC2 instance is running
✅ All Docker containers are up
✅ API Gateway responds to health checks
✅ Frontend loads in browser
✅ GitHub Actions deploys successfully
✅ All microservices are registered in Consul

---

**🚀 Your RevHub platform is now running on AWS!**