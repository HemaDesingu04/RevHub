#!/bin/bash

# RevHub EC2 Instance Setup Script

# Update system
yum update -y

# Install Git
yum install -y git

# Install Java 17
yum install -y java-17-amazon-corretto-devel
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> /home/ec2-user/.bashrc

# Install Maven
cd /opt
wget https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
tar xzf apache-maven-3.9.6-bin.tar.gz
ln -s apache-maven-3.9.6 maven
echo 'export PATH=/opt/maven/bin:$PATH' >> /home/ec2-user/.bashrc

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install Node.js and npm
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Create application directory
mkdir -p /home/ec2-user/revhub
chown ec2-user:ec2-user /home/ec2-user/revhub

# Install htop for monitoring
yum install -y htop

# Create startup script
cat > /home/ec2-user/start-revhub.sh << 'EOF'
#!/bin/bash
cd /home/ec2-user/revhub
git pull origin main
docker-compose down
docker-compose up -d --build
EOF

chmod +x /home/ec2-user/start-revhub.sh
chown ec2-user:ec2-user /home/ec2-user/start-revhub.sh

# Setup environment variables
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> /home/ec2-user/.bashrc
echo 'export PATH=/opt/maven/bin:$PATH' >> /home/ec2-user/.bashrc
echo 'export PATH=/usr/local/bin:$PATH' >> /home/ec2-user/.bashrc

# Log completion
echo "RevHub EC2 setup completed at $(date)" >> /var/log/revhub-setup.log