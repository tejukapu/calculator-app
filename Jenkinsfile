pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "raviteja21k/calculator-app"
        DOCKER_TAG = "latest"
        DOCKER_CREDS = "dockerhub-creds"
        GITHUB_CREDS = "github-creds"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: "${GITHUB_CREDS}",
                    url: 'https://github.com/tejukapu/calculator-app.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$DOCKER_TAG .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE:$DOCKER_TAG'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                sed -i "s|image:.*|image: $DOCKER_IMAGE:$DOCKER_TAG|" deployment.yaml
                kubectl apply -f deployment.yaml
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
