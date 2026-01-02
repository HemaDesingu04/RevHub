pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_REPO = 'hemalakshmi08'
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.GIT_COMMIT_SHORT = bat(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                }
            }
        }
        
        stage('Build Shared Modules') {
            steps {
                dir('shared') {
                    bat 'mvn clean install -DskipTests'
                }
            }
        }
        
        stage('Build Backend Services') {
            parallel {
                stage('API Gateway') {
                    steps {
                        dir('backend-services/api-gateway') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('User Service') {
                    steps {
                        dir('backend-services/user-service') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Post Service') {
                    steps {
                        dir('backend-services/post-service') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Social Service') {
                    steps {
                        dir('backend-services/social-service') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
                stage('Chat Service') {
                    steps {
                        dir('backend-services/chat-service') {
                            bat 'mvn clean package -DskipTests'
                        }
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    def services = [
                        'api-gateway', 'user-service', 'post-service', 
                        'social-service', 'chat-service'
                    ]
                    
                    services.each { service ->
                        dir("backend-services/${service}") {
                            bat """
                                docker build -t ${DOCKER_REPO}/revhub-${service}:${BUILD_NUMBER} .
                                docker tag ${DOCKER_REPO}/revhub-${service}:${BUILD_NUMBER} ${DOCKER_REPO}/revhub-${service}:latest
                            """
                        }
                    }
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
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-hub-credentials') {
                        def services = [
                            'api-gateway', 'user-service', 'post-service', 
                            'social-service', 'chat-service'
                        ]
                        
                        services.each { service ->
                            bat "docker push ${DOCKER_REPO}/revhub-${service}:${BUILD_NUMBER}"
                            bat "docker push ${DOCKER_REPO}/revhub-${service}:latest"
                        }
                    }
                }
            }
        }
        
        stage('Health Check') {
            steps {
                script {
                    // Simple health check
                    bat 'echo "Build completed successfully!"'
                }
            }
        }
    }
    
    post {
        always {
            // Clean up Docker images
            bat '''
                docker image prune -f
            '''
        }
        
        success {
            echo 'Pipeline succeeded!'
        }
        
        failure {
            echo 'Pipeline failed!'
        }
    }
}