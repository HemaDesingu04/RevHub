#!/bin/bash
yum update -y
yum install -y git htop unzip wget curl docker java-17-amazon-corretto-devel
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> /etc/profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /etc/profile
cd /opt
wget https://archive.apache.org/dist/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
tar xzf apache-maven-3.9.4-bin.tar.gz
ln -s apache-maven-3.9.4 maven
echo 'export M2_HOME=/opt/maven' >> /etc/profile
echo 'export PATH=/opt/maven/bin:$PATH' >> /etc/profile
systemctl start docker
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
usermod -a -G docker ec2-user
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs
npm install -g @angular/cli
mkdir -p /home/ec2-user/app
chown ec2-user:ec2-user /home/ec2-user/app
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' >> /home/ec2-user/.bashrc
echo 'export M2_HOME=/opt/maven' >> /home/ec2-user/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH' >> /home/ec2-user/.bashrc