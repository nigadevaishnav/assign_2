pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'nigadevaishnav/assign_2'
        SONARQUBE_URL = 'http://localhost:9000'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'git-credentials', url: 'https://github.com/nigadevaishnav/assign_2.git'
            }
        }

        stage('Build Project') {
            steps {
                sh 'echo "Building project..."'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Scanner') {
                    sh 'echo "Running SonarQube Analysis..."'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d -p 8080:8080 ${DOCKER_IMAGE}'
            }
        }
    }
}
