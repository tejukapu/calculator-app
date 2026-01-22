pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        AWS_REGION = 'eu-north-1'
        AWS_ACCOUNT_ID = '624909705616'
        ECR_REPO = 'calculator-app'
        IMAGE_TAG = 'latest'
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/tejukapu/calculator-app.git',
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
                sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
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
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
