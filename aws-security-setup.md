# AWS Security & SSH Setup Guide

## 🔐 SSH Key Pair Setup

### 1. Create EC2 Key Pair
```bash
# Option 1: Using AWS CLI
aws ec2 create-key-pair --key-name RevHub-KeyPair --query 'KeyMaterial' --output text > RevHub-KeyPair.pem

# Option 2: Using AWS Console
# Go to EC2 → Key Pairs → Create Key Pair
# Name: RevHub-KeyPair
# Download the .pem file
```

### 2. Set Key Permissions (Linux/Mac)
```bash
chmod 400 RevHub-KeyPair.pem
```

### 3. SSH to EC2 Instances
```bash
# Find instance IP from AWS Console or CLI
aws ec2 describe-instances --filters "Name=tag:Name,Values=RevHub-ECS-Instance"

# SSH to instance
ssh -i RevHub-KeyPair.pem ec2-user@<INSTANCE-PUBLIC-IP>
```

## 🛡️ Security Groups Configuration

### ECS Security Group Rules:
- **Port 22**: SSH access (your IP only)
- **Port 80/443**: HTTP/HTTPS from ALB
- **Port 8080-8088**: Microservices ports (from ALB only)
- **Port 2376**: Docker daemon (internal only)

### Database Security Group:
- **Port 3306**: MySQL (from ECS instances only)
- **Port 27017**: MongoDB (from ECS instances only)

## 🔒 IAM Roles & Permissions

### ECS Instance Role Permissions:
- `AmazonEC2ContainerServiceforEC2Role`
- `CloudWatchLogsFullAccess`
- `AmazonEC2ContainerRegistryReadOnly`

### ECS Task Execution Role:
- `AmazonECSTaskExecutionRolePolicy`
- `CloudWatchLogsCreateLogGroup`

## 🌐 Network Security

### VPC Configuration:
- **Public Subnets**: ALB, NAT Gateway
- **Private Subnets**: ECS instances, RDS
- **Internet Gateway**: Public subnet access
- **NAT Gateway**: Private subnet outbound access

### Security Best Practices:
1. **Principle of Least Privilege**
2. **No direct internet access to ECS instances**
3. **Database in private subnets only**
4. **ALB terminates SSL/TLS**
5. **CloudWatch logging enabled**

## 🔧 Troubleshooting Access

### SSH Connection Issues:
```bash
# Check security group allows SSH from your IP
aws ec2 describe-security-groups --group-ids sg-xxxxxxxxx

# Verify key pair exists
aws ec2 describe-key-pairs --key-names RevHub-KeyPair

# Test connection with verbose output
ssh -v -i RevHub-KeyPair.pem ec2-user@<IP>
```

### ECS Container Access:
```bash
# SSH to ECS instance first
ssh -i RevHub-KeyPair.pem ec2-user@<INSTANCE-IP>

# List running containers
docker ps

# Access container logs
docker logs <container-id>

# Execute commands in container
docker exec -it <container-id> /bin/bash
```

## 📊 Monitoring & Logging

### CloudWatch Logs:
- `/ecs/revhub-api-gateway`
- `/ecs/revhub-user-service`
- `/ecs/revhub-post-service`

### ECS Service Monitoring:
```bash
# Check service status
aws ecs describe-services --cluster RevHub-Cluster --services revhub-api-gateway

# View task logs
aws logs get-log-events --log-group-name /ecs/revhub-api-gateway --log-stream-name <stream-name>
```

## 🚨 Security Alerts

### CloudWatch Alarms:
- High CPU usage
- Memory utilization
- Failed health checks
- Unauthorized access attempts

### AWS Config Rules:
- Security group compliance
- Encryption at rest
- Public access restrictions

## 🔄 Backup & Recovery

### RDS Automated Backups:
- 7-day retention period
- Point-in-time recovery
- Multi-AZ for high availability

### ECS Service Recovery:
- Auto Scaling handles instance failures
- ECS reschedules failed tasks
- ALB health checks ensure availability

## 📋 Security Checklist

- [ ] SSH key pair created and secured
- [ ] Security groups configured with minimal access
- [ ] IAM roles follow least privilege
- [ ] Database in private subnets
- [ ] SSL/TLS certificates configured
- [ ] CloudWatch logging enabled
- [ ] Monitoring and alerts set up
- [ ] Backup strategy implemented
- [ ] Access logs reviewed regularly

## 🆘 Emergency Access

### Bastion Host (Optional):
```yaml
BastionHost:
  Type: AWS::EC2::Instance
  Properties:
    ImageId: ami-0c02fb55956c7d316
    InstanceType: t3.micro
    KeyName: !Ref KeyPairName
    SubnetId: !Ref PublicSubnet1
    SecurityGroupIds:
      - !Ref BastionSecurityGroup
```

### Session Manager (Recommended):
- No SSH keys required
- Audit trail in CloudTrail
- Browser-based access
- IAM-based permissions