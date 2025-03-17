pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nigadevaishnav/assign_2"
        SONARQUBE_SERVER = "SonarQube"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/nigadevaishnav/assign_2.git'
            }
        }

        stage('Build and Test') {
            steps {
                script {
                    def language = "java"  // Change to "nodejs" if using JavaScript

                    if (language == "java") {
                        sh 'mvn clean package'
                    } else if (language == "nodejs") {
                        sh 'npm install && npm test'
                    }
                }
            }
        }

        stage('Code Analysis with SonarQube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar' // For Java projects
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-credentials', variable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u nigadevaishnav --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh 'docker run -d --name assign_2_container -p 8080:8080 $DOCKER_IMAGE'
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs!"
        }
    }
}

