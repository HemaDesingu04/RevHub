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
                    sh 'cd shared && mvn clean install -DskipTests'
                    
                    def services = ['api-gateway', 'user-service', 'post-service', 
                                  'social-service', 'chat-service', 'notification-service',
                                  'feed-service', 'search-service', 'saga-orchestrator']
                    
                    services.each { service ->
                        sh "cd backend-services/${service} && mvn clean package -DskipTests"
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
                        sh "docker build -t ${ECR_REGISTRY}/revhub-${service}:${BUILD_NUMBER} backend-services/${service}"
                        sh "docker tag ${ECR_REGISTRY}/revhub-${service}:${BUILD_NUMBER} ${ECR_REGISTRY}/revhub-${service}:latest"
                    }
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    
                    def services = ['api-gateway', 'user-service', 'post-service', 
                                  'social-service', 'chat-service', 'notification-service',
                                  'feed-service', 'search-service', 'saga-orchestrator']
                    
                    services.each { service ->
                        sh "docker push ${ECR_REGISTRY}/revhub-${service}:${BUILD_NUMBER}"
                        sh "docker push ${ECR_REGISTRY}/revhub-${service}:latest"
                    }
                }
            }
        }
        
        stage('Deploy to ECS') {
            steps {
                script {
                    sh "aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}"
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