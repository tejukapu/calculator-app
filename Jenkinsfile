pipeline {
    agent any

    environment {
        AWS_REGION = "eu-north-1"
        ECR_REPO = "624909705616.dkr.ecr.eu-north-1.amazonaws.com/calculator-app"
        IMAGE_NAME = "calculator-app"
    }

    stages {

        stage('Build with Maven') {
            steps {
                echo "Building application with Maven..."
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker Image..."
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                echo "Logging into AWS ECR..."
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_REPO
                '''
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                echo "Tagging & pushing image to ECR..."
                sh '''
                docker tag $IMAGE_NAME:latest $ECR_REPO:latest
                docker push $ECR_REPO:latest
                '''
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline completed successfully 🚀"
        }
        failure {
            echo "Pipeline failed ❌ Please check logs."
        }
    }
}
