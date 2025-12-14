pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '123456789012.dkr.ecr.us-east-1.amazonaws.com'
        ECS_CLUSTER = 'revhub-cluster'
        ECS_SERVICE = 'revhub-service'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Maven Projects') {
            steps {
                script {
                    bat 'cd shared && mvn clean install -DskipTests'
                    
                    def services = ['api-gateway', 'user-service', 'post-service', 
                                  'social-service', 'chat-service', 'notification-service',
                                  'feed-service', 'search-service', 'saga-orchestrator']
                    
                    services.each { service ->
                        bat "cd backend-services\\${service} && mvn clean package -DskipTests"
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    def services = ['api-gateway', 'user-service', 'post-service', 
                                  'social-service', 'chat-service', 'notification-service',
                                  'feed-service', 'search-service', 'saga-orchestrator']
                    
                    services.each { service ->
                        bat "docker build -t ${ECR_REGISTRY}/revhub-${service}:${BUILD_NUMBER} backend-services/${service}"
                        bat "docker tag ${ECR_REGISTRY}/revhub-${service}:${BUILD_NUMBER} ${ECR_REGISTRY}/revhub-${service}:latest"
                    }
                }
            }
        }
        
        stage('Local Deployment') {
            steps {
                script {
                    bat '''
                        echo "Docker images built successfully!"
                        docker images | findstr revhub
                        echo "Ready for deployment!"
                    '''
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}