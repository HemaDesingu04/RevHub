#!/bin/bash

# RevHub Jenkins Setup Script
# This script sets up Jenkins with all required plugins and configurations

set -e

echo "🚀 Setting up Jenkins for RevHub Microservices Platform..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root"
   exit 1
fi

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Create Jenkins directory structure
echo "📁 Creating Jenkins directory structure..."
mkdir -p jenkins/{data,docker}

# Create Jenkins Docker Compose file
cat > jenkins/docker/docker-compose.yml << 'EOF'
version: '3.8'

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: revhub-jenkins
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
      - /usr/local/bin/docker-compose:/usr/local/bin/docker-compose
    environment:
      JAVA_OPTS: "-Xmx2048m -Djava.awt.headless=true"
      JENKINS_OPTS: "--httpPort=8080"
    restart: unless-stopped
    networks:
      - jenkins-network

  jenkins-agent:
    image: jenkins/inbound-agent:latest
    container_name: revhub-jenkins-agent
    environment:
      JENKINS_URL: http://jenkins:8080
      JENKINS_SECRET: ${JENKINS_AGENT_SECRET}
      JENKINS_AGENT_NAME: docker-agent
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
    depends_on:
      - jenkins
    networks:
      - jenkins-network
    restart: unless-stopped

networks:
  jenkins-network:
    driver: bridge

volumes:
  jenkins_data:
EOF

# Create Jenkins plugins list
cat > jenkins/plugins.txt << 'EOF'
ant:latest
antisamy-markup-formatter:latest
build-timeout:latest
credentials-binding:latest
email-ext:latest
git:latest
github:latest
gradle:latest
ldap:latest
mailer:latest
matrix-auth:latest
pam-auth:latest
pipeline-github-lib:latest
pipeline-stage-view:latest
ssh-slaves:latest
timestamper:latest
workflow-aggregator:latest
ws-cleanup:latest
docker-workflow:latest
docker-plugin:latest
kubernetes:latest
nodejs:latest
maven-plugin:latest
sonar:latest
jacoco:latest
junit:latest
performance:latest
htmlpublisher:latest
checkstyle:latest
warnings-ng:latest
blueocean:latest
prometheus:latest
EOF

# Create Jenkins configuration as code
mkdir -p jenkins/casc
cat > jenkins/casc/jenkins.yaml << 'EOF'
jenkins:
  systemMessage: "RevHub Microservices CI/CD Pipeline"
  numExecutors: 2
  mode: NORMAL
  scmCheckoutRetryCount: 3
  
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: "admin"
          password: "${JENKINS_ADMIN_PASSWORD}"
          
  authorizationStrategy:
    globalMatrix:
      permissions:
        - "Overall/Administer:admin"
        - "Overall/Read:authenticated"
        
  remotingSecurity:
    enabled: true

tool:
  git:
    installations:
      - name: "Default"
        home: "/usr/bin/git"
        
  maven:
    installations:
      - name: "Maven-3.8"
        properties:
          - installSource:
              installers:
                - maven:
                    id: "3.8.6"
                    
  nodejs:
    installations:
      - name: "NodeJS-18"
        properties:
          - installSource:
              installers:
                - nodeJSInstaller:
                    id: "18.17.0"
                    npmPackagesRefreshHours: 72

credentials:
  system:
    domainCredentials:
      - credentials:
          - usernamePassword:
              scope: GLOBAL
              id: "docker-registry-credentials"
              username: "${DOCKER_REGISTRY_USERNAME}"
              password: "${DOCKER_REGISTRY_PASSWORD}"
              description: "Docker Registry Credentials"
              
          - string:
              scope: GLOBAL
              id: "github-token"
              secret: "${GITHUB_TOKEN}"
              description: "GitHub Personal Access Token"

jobs:
  - script: |
      multibranchPipelineJob('revhub-pipeline') {
        branchSources {
          github {
            id('revhub-repo')
            scanCredentialsId('github-token')
            repoOwner('your-username')
            repository('Microservices_RevHub')
          }
        }
        orphanedItemStrategy {
          discardOldItems {
            numToKeep(20)
          }
        }
        triggers {
          periodic(5)
        }
      }
EOF

# Create environment file template
cat > jenkins/.env.example << 'EOF'
# Jenkins Configuration
JENKINS_ADMIN_PASSWORD=admin123
JENKINS_AGENT_SECRET=your-agent-secret

# Docker Registry
DOCKER_REGISTRY_USERNAME=your-username
DOCKER_REGISTRY_PASSWORD=your-password

# GitHub
GITHUB_TOKEN=your-github-token

# Database Passwords
MYSQL_ROOT_PASSWORD=secure-mysql-password
MONGO_ROOT_PASSWORD=secure-mongo-password

# Monitoring
GRAFANA_PASSWORD=secure-grafana-password
EOF

# Create startup script
cat > jenkins/start-jenkins.sh << 'EOF'
#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "❌ .env file not found. Please copy .env.example to .env and configure it."
    exit 1
fi

# Start Jenkins
echo "🚀 Starting Jenkins..."
cd docker
docker-compose up -d

echo "✅ Jenkins is starting up..."
echo "📝 Access Jenkins at: http://localhost:8080"
echo "👤 Default admin credentials: admin / ${JENKINS_ADMIN_PASSWORD}"
echo ""
echo "⏳ Waiting for Jenkins to be ready..."

# Wait for Jenkins to be ready
while ! curl -s http://localhost:8080/login > /dev/null; do
    echo "   Still waiting..."
    sleep 10
done

echo "✅ Jenkins is ready!"
echo ""
echo "🔧 Next steps:"
echo "1. Access Jenkins at http://localhost:8080"
echo "2. Configure your GitHub repository"
echo "3. Set up Docker registry credentials"
echo "4. Run your first pipeline!"
EOF

chmod +x jenkins/start-jenkins.sh

# Create stop script
cat > jenkins/stop-jenkins.sh << 'EOF'
#!/bin/bash

echo "🛑 Stopping Jenkins..."
cd docker
docker-compose down

echo "✅ Jenkins stopped."
EOF

chmod +x jenkins/stop-jenkins.sh

# Create monitoring configuration
mkdir -p monitoring
cat > monitoring/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'jenkins'
    static_configs:
      - targets: ['jenkins:8080']
    metrics_path: '/prometheus'
    
  - job_name: 'revhub-services'
    static_configs:
      - targets: 
        - 'api-gateway:8080'
        - 'user-service:8081'
        - 'post-service:8082'
        - 'social-service:8083'
        - 'chat-service:8084'
        - 'notification-service:8085'
        - 'feed-service:8086'
        - 'search-service:8087'
        - 'saga-orchestrator:8088'
    metrics_path: '/actuator/prometheus'
EOF

echo "✅ Jenkins setup completed!"
echo ""
echo "📋 Setup Summary:"
echo "   📁 Jenkins files created in ./jenkins/"
echo "   🐳 Docker Compose files ready"
echo "   ⚙️  Configuration as Code prepared"
echo "   📊 Monitoring configuration added"
echo ""
echo "🚀 To start Jenkins:"
echo "   1. cd jenkins"
echo "   2. cp .env.example .env"
echo "   3. Edit .env with your credentials"
echo "   4. ./start-jenkins.sh"
echo ""
echo "🔗 Useful URLs after startup:"
echo "   Jenkins: http://localhost:8080"
echo "   Prometheus: http://localhost:9090"
echo "   Grafana: http://localhost:3000"