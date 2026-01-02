# 🚀 Jenkins CI/CD for RevHub Microservices

Complete Jenkins setup and CI/CD pipeline for the RevHub microservices platform.

## 📋 Overview

This Jenkins setup provides:
- **Automated builds** for all 9 backend services and 6 frontend applications
- **Parallel execution** for faster build times
- **Docker image creation** and registry push
- **Security scanning** with Trivy
- **Automated testing** for both backend and frontend
- **Multi-environment deployment** (staging/production)
- **Health checks** and monitoring integration

## 🏗️ Architecture

```
GitHub Repository
    ↓
Jenkins Pipeline (Jenkinsfile)
    ↓
Build → Test → Security Scan → Docker Build → Deploy
    ↓
Staging Environment → Production Environment
```

## 🚀 Quick Start

### 1. Setup Jenkins

**Windows:**
```bash
setup-jenkins.bat
```

**Linux/Mac:**
```bash
chmod +x setup-jenkins.sh
./setup-jenkins.sh
```

### 2. Configure Environment

```bash
cd jenkins
cp .env.example .env
# Edit .env with your credentials
```

### 3. Start Jenkins

**Windows:**
```bash
cd jenkins
start-jenkins.bat
```

**Linux/Mac:**
```bash
cd jenkins
./start-jenkins.sh
```

### 4. Access Jenkins

- **URL**: http://localhost:8080
- **Username**: admin
- **Password**: admin123 (or your configured password)

## 📦 Pipeline Stages

### 1. **Checkout**
- Clones the repository
- Gets Git commit information

### 2. **Build Shared Modules**
- Builds common DTOs and utilities
- Creates shared JAR files

### 3. **Build Backend Services** (Parallel)
- API Gateway
- User Service
- Post Service
- Social Service
- Chat Service
- Notification Service
- Feed Service
- Search Service
- Saga Orchestrator

### 4. **Build Frontend Services** (Parallel)
- Shell App
- Auth Microfrontend
- Feed Microfrontend
- Profile Microfrontend
- Chat Microfrontend
- Notifications Microfrontend

### 5. **Run Tests** (Parallel)
- Backend unit tests with Maven
- Frontend tests with npm/Angular
- Test result publishing

### 6. **Build Docker Images** (Parallel)
- Creates Docker images for all services
- Tags with build number and latest

### 7. **Security Scan**
- Trivy vulnerability scanning
- Security report generation

### 8. **Push to Registry**
- Pushes images to Docker registry
- Only on main/develop branches

### 9. **Deploy to Staging**
- Automatic deployment on develop branch
- Uses docker-compose.staging.yml

### 10. **Deploy to Production**
- Manual approval required
- Only on main branch
- Uses docker-compose.prod.yml

### 11. **Health Check**
- Verifies all services are running
- Checks health endpoints

## 🔧 Configuration

### Environment Variables

```bash
# Jenkins Configuration
JENKINS_ADMIN_PASSWORD=your-secure-password

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
```

### Jenkins Plugins

The setup automatically installs these essential plugins:

- **Pipeline**: Workflow Aggregator, Pipeline Stage View
- **SCM**: Git, GitHub
- **Build Tools**: Maven, NodeJS, Gradle
- **Docker**: Docker Workflow, Docker Plugin
- **Testing**: JUnit, JaCoCo, Performance
- **Security**: Credentials Binding
- **Monitoring**: Prometheus, Blue Ocean
- **Notifications**: Email Extension

### Docker Registry Configuration

1. Go to Jenkins → Manage Jenkins → Manage Credentials
2. Add Docker registry credentials with ID: `docker-registry-credentials`
3. Update `DOCKER_REGISTRY` in Jenkinsfile

## 🌍 Multi-Environment Deployment

### Staging Environment
- **Trigger**: Automatic on `develop` branch
- **File**: `docker-compose.staging.yml`
- **Purpose**: Testing and validation

### Production Environment
- **Trigger**: Manual approval on `main` branch
- **File**: `docker-compose.prod.yml`
- **Features**: 
  - Resource limits
  - Multiple replicas
  - Monitoring integration
  - Security hardening

## 📊 Monitoring Integration

### Prometheus Metrics
- Jenkins build metrics
- Application health metrics
- Infrastructure monitoring

### Grafana Dashboards
- Build success/failure rates
- Deployment frequency
- Service health status
- Performance metrics

## 🔒 Security Features

### Trivy Security Scanning
- Container vulnerability scanning
- High/Critical severity alerts
- Build failure on security issues

### Secrets Management
- Jenkins Credentials Store
- Environment variable encryption
- No hardcoded secrets in code

## 🧪 Testing Strategy

### Backend Testing
```bash
mvn test
```
- Unit tests with JUnit
- Integration tests
- Code coverage with JaCoCo

### Frontend Testing
```bash
npm test -- --watch=false --browsers=ChromeHeadless
```
- Unit tests with Jasmine/Karma
- Component tests
- E2E tests (optional)

## 📈 Pipeline Optimization

### Parallel Execution
- Backend services build in parallel
- Frontend services build in parallel
- Tests run concurrently

### Caching Strategy
- Maven dependencies cached
- npm packages cached
- Docker layer caching

### Resource Management
- Memory limits for containers
- CPU allocation
- Disk space cleanup

## 🚨 Troubleshooting

### Common Issues

**1. Docker Permission Denied**
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**2. Out of Memory**
```bash
# Increase Jenkins memory
JAVA_OPTS="-Xmx4096m"
```

**3. Build Timeout**
```bash
# Increase timeout in Jenkinsfile
timeout(time: 30, unit: 'MINUTES')
```

**4. Registry Push Failed**
```bash
# Check credentials and network
docker login your-registry.com
```

### Log Locations

- **Jenkins Logs**: `/var/jenkins_home/logs/`
- **Build Logs**: Jenkins UI → Build → Console Output
- **Container Logs**: `docker logs <container-name>`

## 📚 Best Practices

### 1. **Branch Strategy**
- `main` → Production deployments
- `develop` → Staging deployments
- `feature/*` → Build and test only

### 2. **Version Management**
- Use build numbers for image tags
- Semantic versioning for releases
- Git commit SHA for traceability

### 3. **Security**
- Regular security scans
- Credential rotation
- Access control reviews

### 4. **Monitoring**
- Set up alerts for failed builds
- Monitor deployment success rates
- Track performance metrics

## 🔄 Maintenance

### Regular Tasks

**Weekly:**
- Review failed builds
- Update security patches
- Clean up old artifacts

**Monthly:**
- Update Jenkins plugins
- Review resource usage
- Backup configurations

**Quarterly:**
- Security audit
- Performance optimization
- Disaster recovery testing

## 📞 Support

### Useful Commands

```bash
# View Jenkins logs
docker logs revhub-jenkins

# Restart Jenkins
docker-compose restart jenkins

# Clean up Docker
docker system prune -f

# Check service health
curl http://localhost:8080/actuator/health
```

### Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)

## 🎯 Success Metrics

Track these KPIs for your CI/CD pipeline:

- **Build Success Rate**: >95%
- **Build Time**: <15 minutes
- **Deployment Frequency**: Multiple times per day
- **Mean Time to Recovery**: <30 minutes
- **Security Scan Pass Rate**: 100%

---

**🎉 Your RevHub microservices platform is now ready for enterprise-grade CI/CD!**