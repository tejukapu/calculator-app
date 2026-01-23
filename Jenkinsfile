pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'Java-21'
    }

    environment {
        AWS_REGION = 'eu-north-1'
        AWS_ACCOUNT_ID = '624909705616'
        ECR_REPO = 'calculator-app'
        // Uses build number (1, 2, 3) to prevent image conflicts
        IMAGE_TAG = "${env.BUILD_NUMBER}" 
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}://{ECR_REPO}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com',
                    credentialsId: 'GitHub Cred'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds image as calculator-app:1, calculator-app:2, etc.
                sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URI}"
            }
        }

        stage('Tag & Push Image') {
            steps {
                sh '''
                docker tag $ECR_REPO:$IMAGE_TAG $ECR_URI:$IMAGE_TAG
                docker push $ECR_URI:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Image pushed: ${ECR_URI}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline failed! Check the logs above for errors."
        }
    }
}
