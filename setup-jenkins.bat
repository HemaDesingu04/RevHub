@echo off
setlocal enabledelayedexpansion

echo 🚀 Setting up Jenkins for RevHub Microservices Platform...

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    echo 📥 Download from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Check if Docker Compose is available
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Compose is not available. Please ensure Docker Desktop is running.
    pause
    exit /b 1
)

echo 📁 Creating Jenkins directory structure...
if not exist jenkins mkdir jenkins
if not exist jenkins\data mkdir jenkins\data
if not exist jenkins\docker mkdir jenkins\docker
if not exist monitoring mkdir monitoring

echo 📝 Creating Jenkins Docker Compose file...
(
echo version: '3.8'
echo.
echo services:
echo   jenkins:
echo     image: jenkins/jenkins:lts
echo     container_name: revhub-jenkins
echo     user: root
echo     ports:
echo       - "8080:8080"
echo       - "50000:50000"
echo     volumes:
echo       - jenkins_data:/var/jenkins_home
echo       - /var/run/docker.sock:/var/run/docker.sock
echo       - ../data:/var/jenkins_home/casc_configs
echo     environment:
echo       JAVA_OPTS: "-Xmx2048m -Djava.awt.headless=true"
echo       JENKINS_OPTS: "--httpPort=8080"
echo       CASC_JENKINS_CONFIG: "/var/jenkins_home/casc_configs"
echo     restart: unless-stopped
echo     networks:
echo       - jenkins-network
echo.
echo networks:
echo   jenkins-network:
echo     driver: bridge
echo.
echo volumes:
echo   jenkins_data:
) > jenkins\docker\docker-compose.yml

echo 📝 Creating Jenkins plugins list...
(
echo ant:latest
echo antisamy-markup-formatter:latest
echo build-timeout:latest
echo credentials-binding:latest
echo email-ext:latest
echo git:latest
echo github:latest
echo gradle:latest
echo ldap:latest
echo mailer:latest
echo matrix-auth:latest
echo pam-auth:latest
echo pipeline-github-lib:latest
echo pipeline-stage-view:latest
echo ssh-slaves:latest
echo timestamper:latest
echo workflow-aggregator:latest
echo ws-cleanup:latest
echo docker-workflow:latest
echo docker-plugin:latest
echo kubernetes:latest
echo nodejs:latest
echo maven-plugin:latest
echo sonar:latest
echo jacoco:latest
echo junit:latest
echo performance:latest
echo htmlpublisher:latest
echo checkstyle:latest
echo warnings-ng:latest
echo blueocean:latest
echo prometheus:latest
echo configuration-as-code:latest
) > jenkins\plugins.txt

echo 📝 Creating Jenkins Configuration as Code...
(
echo jenkins:
echo   systemMessage: "RevHub Microservices CI/CD Pipeline"
echo   numExecutors: 2
echo   mode: NORMAL
echo   scmCheckoutRetryCount: 3
echo.
echo   securityRealm:
echo     local:
echo       allowsSignup: false
echo       users:
echo         - id: "admin"
echo           password: "admin123"
echo.
echo   authorizationStrategy:
echo     globalMatrix:
echo       permissions:
echo         - "Overall/Administer:admin"
echo         - "Overall/Read:authenticated"
echo.
echo tool:
echo   git:
echo     installations:
echo       - name: "Default"
echo         home: "git"
echo.
echo   maven:
echo     installations:
echo       - name: "Maven-3.8"
echo         properties:
echo           - installSource:
echo               installers:
echo                 - maven:
echo                     id: "3.8.6"
echo.
echo   nodejs:
echo     installations:
echo       - name: "NodeJS-18"
echo         properties:
echo           - installSource:
echo               installers:
echo                 - nodeJSInstaller:
echo                     id: "18.17.0"
echo                     npmPackagesRefreshHours: 72
) > jenkins\data\jenkins.yaml

echo 📝 Creating environment file template...
(
echo # Jenkins Configuration
echo JENKINS_ADMIN_PASSWORD=admin123
echo.
echo # Docker Registry
echo DOCKER_REGISTRY_USERNAME=your-username
echo DOCKER_REGISTRY_PASSWORD=your-password
echo.
echo # GitHub
echo GITHUB_TOKEN=your-github-token
echo.
echo # Database Passwords
echo MYSQL_ROOT_PASSWORD=secure-mysql-password
echo MONGO_ROOT_PASSWORD=secure-mongo-password
echo.
echo # Monitoring
echo GRAFANA_PASSWORD=secure-grafana-password
) > jenkins\.env.example

echo 📝 Creating startup script...
(
echo @echo off
echo echo 🚀 Starting Jenkins...
echo.
echo if not exist .env ^(
echo     echo ❌ .env file not found. Please copy .env.example to .env and configure it.
echo     pause
echo     exit /b 1
echo ^)
echo.
echo cd docker
echo docker-compose up -d
echo.
echo echo ✅ Jenkins is starting up...
echo echo 📝 Access Jenkins at: http://localhost:8080
echo echo 👤 Default admin credentials: admin / admin123
echo echo.
echo echo ⏳ Waiting for Jenkins to be ready...
echo.
echo :wait_loop
echo curl -s http://localhost:8080/login >nul 2>&1
echo if errorlevel 1 ^(
echo     echo    Still waiting...
echo     timeout /t 10 /nobreak >nul
echo     goto wait_loop
echo ^)
echo.
echo echo ✅ Jenkins is ready!
echo echo.
echo echo 🔧 Next steps:
echo echo 1. Access Jenkins at http://localhost:8080
echo echo 2. Configure your GitHub repository
echo echo 3. Set up Docker registry credentials
echo echo 4. Run your first pipeline!
echo pause
) > jenkins\start-jenkins.bat

echo 📝 Creating stop script...
(
echo @echo off
echo echo 🛑 Stopping Jenkins...
echo cd docker
echo docker-compose down
echo echo ✅ Jenkins stopped.
echo pause
) > jenkins\stop-jenkins.bat

echo 📝 Creating monitoring configuration...
(
echo global:
echo   scrape_interval: 15s
echo.
echo scrape_configs:
echo   - job_name: 'jenkins'
echo     static_configs:
echo       - targets: ['jenkins:8080']
echo     metrics_path: '/prometheus'
echo.
echo   - job_name: 'revhub-services'
echo     static_configs:
echo       - targets:
echo         - 'api-gateway:8080'
echo         - 'user-service:8081'
echo         - 'post-service:8082'
echo         - 'social-service:8083'
echo         - 'chat-service:8084'
echo         - 'notification-service:8085'
echo         - 'feed-service:8086'
echo         - 'search-service:8087'
echo         - 'saga-orchestrator:8088'
echo     metrics_path: '/actuator/prometheus'
) > monitoring\prometheus.yml

echo ✅ Jenkins setup completed!
echo.
echo 📋 Setup Summary:
echo    📁 Jenkins files created in .\jenkins\
echo    🐳 Docker Compose files ready
echo    ⚙️  Configuration as Code prepared
echo    📊 Monitoring configuration added
echo.
echo 🚀 To start Jenkins:
echo    1. cd jenkins
echo    2. copy .env.example .env
echo    3. Edit .env with your credentials
echo    4. start-jenkins.bat
echo.
echo 🔗 Useful URLs after startup:
echo    Jenkins: http://localhost:8080
echo    Prometheus: http://localhost:9090
echo    Grafana: http://localhost:3000
echo.
pause