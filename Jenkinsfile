pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'your-registry.com'
        DOCKER_REPO = 'revhub'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        GIT_COMMIT_SHORT = "${env.GIT_COMMIT?.take(7)}"
    }
    
    tools {
        maven 'Maven-3.8'
        nodejs 'NodeJS-18'
        dockerTool 'Docker'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.GIT_COMMIT_SHORT = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                }
            }
        }
        
        stage('Build Shared Modules') {
            steps {
                dir('shared') {
                    sh 'mvn clean install -DskipTests'
                }
            }
        }
        
        stage('Build Backend Services') {
            parallel {
                stage('API Gateway') {
                    steps {
                        dir('backend-services/api-gateway') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('User Service') {
                    steps {
                        dir('backend-services/user-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Post Service') {
                    steps {
                        dir('backend-services/post-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Social Service') {
                    steps {
                        dir('backend-services/social-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Chat Service') {
                    steps {
                        dir('backend-services/chat-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Notification Service') {
                    steps {
                        dir('backend-services/notification-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Feed Service') {
                    steps {
                        dir('backend-services/feed-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Search Service') {
                    steps {
                        dir('backend-services/search-service') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Saga Orchestrator') {
                    steps {
                        dir('backend-services/saga-orchestrator') {
                            sh 'mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }
        
        stage('Build Frontend Services') {
            parallel {
                stage('Shell App') {
                    steps {
                        dir('frontend-services/shell-app') {
                            sh 'npm ci'
                            sh 'npm run build'
                        }
                    }
                }
                stage('Auth Microfrontend') {
                    steps {
                        dir('frontend-services/auth-microfrontend') {
                            sh 'npm ci'
                            sh 'npm run build'
                        }
                    }
                }
                stage('Feed Microfrontend') {
                    steps {
                        dir('frontend-services/feed-microfrontend') {
                            sh 'npm ci'
                            sh 'npm run build'
                        }
                    }
                }
                stage('Profile Microfrontend') {
                    steps {
                        dir('frontend-services/profile-microfrontend') {
                            sh 'npm ci'
                            sh 'npm run build'
                        }
                    }
                }
                stage('Chat Microfrontend') {
                    steps {
                        dir('frontend-services/chat-microfrontend') {
                            sh 'npm ci'
                            sh 'npm run build'
                        }
                    }
                }
                stage('Notifications Microfrontend') {
                    steps {
                        dir('frontend-services/notifications-microfrontend') {
                            sh 'npm ci'
                            sh 'npm run build'
                        }
                    }
                }
            }
        }
        
        stage('Run Tests') {
            parallel {
                stage('Backend Tests') {
                    steps {
                        script {
                            def services = [
                                'api-gateway', 'user-service', 'post-service', 
                                'social-service', 'chat-service', 'notification-service',
                                'feed-service', 'search-service', 'saga-orchestrator'
                            ]
                            
                            services.each { service ->
                                dir("backend-services/${service}") {
                                    sh 'mvn test'
                                }
                            }
                        }
                    }
                    post {
                        always {
                            publishTestResults testResultsPattern: '**/target/surefire-reports/*.xml'
                        }
                    }
                }
                stage('Frontend Tests') {
                    steps {
                        script {
                            def frontends = [
                                'shell-app', 'auth-microfrontend', 'feed-microfrontend',
                                'profile-microfrontend', 'chat-microfrontend', 'notifications-microfrontend'
                            ]
                            
                            frontends.each { frontend ->
                                dir("frontend-services/${frontend}") {
                                    sh 'npm test -- --watch=false --browsers=ChromeHeadless'
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            parallel {
                stage('Backend Images') {
                    steps {
                        script {
                            def services = [
                                'api-gateway', 'user-service', 'post-service', 
                                'social-service', 'chat-service', 'notification-service',
                                'feed-service', 'search-service', 'saga-orchestrator'
                            ]
                            
                            services.each { service ->
                                dir("backend-services/${service}") {
                                    sh """
                                        docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPO}-${service}:${BUILD_NUMBER} .
                                        docker tag ${DOCKER_REGISTRY}/${DOCKER_REPO}-${service}:${BUILD_NUMBER} ${DOCKER_REGISTRY}/${DOCKER_REPO}-${service}:latest
                                    """
                                }
                            }
                        }
                    }
                }
                stage('Frontend Images') {
                    steps {
                        script {
                            def frontends = [
                                'shell-app', 'auth-microfrontend', 'feed-microfrontend',
                                'profile-microfrontend', 'chat-microfrontend', 'notifications-microfrontend'
                            ]
                            
                            frontends.each { frontend ->
                                dir("frontend-services/${frontend}") {
                                    sh """
                                        docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPO}-${frontend}:${BUILD_NUMBER} .
                                        docker tag ${DOCKER_REGISTRY}/${DOCKER_REPO}-${frontend}:${BUILD_NUMBER} ${DOCKER_REGISTRY}/${DOCKER_REPO}-${frontend}:latest
                                    """
                                }
                            }
                        }
                    }
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    // Trivy security scanning
                    sh '''
                        # Install Trivy if not present
                        if ! command -v trivy &> /dev/null; then
                            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
                        fi
                        
                        # Scan Docker images
                        trivy image --exit-code 0 --severity HIGH,CRITICAL ${DOCKER_REGISTRY}/${DOCKER_REPO}-user-service:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Push to Registry') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-registry-credentials') {
                        def services = [
                            'api-gateway', 'user-service', 'post-service', 
                            'social-service', 'chat-service', 'notification-service',
                            'feed-service', 'search-service', 'saga-orchestrator',
                            'shell-app', 'auth-microfrontend', 'feed-microfrontend',
                            'profile-microfrontend', 'chat-microfrontend', 'notifications-microfrontend'
                        ]
                        
                        services.each { service ->
                            sh "docker push ${DOCKER_REGISTRY}/${DOCKER_REPO}-${service}:${BUILD_NUMBER}"
                            sh "docker push ${DOCKER_REGISTRY}/${DOCKER_REPO}-${service}:latest"
                        }
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    // Update docker-compose with new image tags
                    sh """
                        sed -i 's|image: .*revhub-|image: ${DOCKER_REGISTRY}/${DOCKER_REPO}-|g' docker-compose.staging.yml
                        sed -i 's|:latest|:${BUILD_NUMBER}|g' docker-compose.staging.yml
                    """
                    
                    // Deploy to staging
                    sh '''
                        docker-compose -f docker-compose.staging.yml down
                        docker-compose -f docker-compose.staging.yml up -d
                    '''
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Manual approval for production
                    input message: 'Deploy to Production?', ok: 'Deploy'
                    
                    // Update production docker-compose
                    sh """
                        sed -i 's|image: .*revhub-|image: ${DOCKER_REGISTRY}/${DOCKER_REPO}-|g' docker-compose.prod.yml
                        sed -i 's|:latest|:${BUILD_NUMBER}|g' docker-compose.prod.yml
                    """
                    
                    // Deploy to production
                    sh '''
                        docker-compose -f docker-compose.prod.yml down
                        docker-compose -f docker-compose.prod.yml up -d
                    '''
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    // Wait for services to start
                    sleep(60)
                    
                    // Health check endpoints
                    def services = [
                        'api-gateway:8080',
                        'user-service:8081',
                        'post-service:8082',
                        'social-service:8083'
                    ]
                    
                    services.each { service ->
                        def (serviceName, port) = service.split(':')
                        sh """
                            curl -f http://localhost:${port}/actuator/health || exit 1
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Clean up Docker images
            sh '''
                docker image prune -f
                docker system prune -f --volumes
            '''
            
            // Archive artifacts
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
            archiveArtifacts artifacts: '**/dist/**', fingerprint: true
        }
        
        success {
            echo 'Pipeline succeeded!'
            // Send success notification
            emailext (
                subject: "✅ RevHub Pipeline Success - Build #${BUILD_NUMBER}",
                body: "RevHub deployment completed successfully!\n\nBuild: ${BUILD_NUMBER}\nCommit: ${GIT_COMMIT_SHORT}",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        
        failure {
            echo 'Pipeline failed!'
            // Send failure notification
            emailext (
                subject: "❌ RevHub Pipeline Failed - Build #${BUILD_NUMBER}",
                body: "RevHub deployment failed!\n\nBuild: ${BUILD_NUMBER}\nCommit: ${GIT_COMMIT_SHORT}\n\nCheck Jenkins for details.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
    }
}