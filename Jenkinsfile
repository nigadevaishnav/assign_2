pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nigadevaishnav/assign_2"
        DOCKER_CREDENTIALS = "dockerhub-credentials"
        SONARQUBE_SERVER = "SonarQube"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/nigadevaishnav/assign_2.git'
            }
        }

        stage('Build & Test with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Run SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS}", url: ""]) {
                        sh "docker login -u nigadevaishnav -p ${DOCKER_HUB_PASSWORD}"
                        sh "docker tag ${DOCKER_IMAGE} nigadevaishnav/assign_2:latest"
                        sh "docker push nigadevaishnav/assign_2:latest"
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    sh "docker run -d -p 8080:8080 --name assign_2_container ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment completed successfully!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

