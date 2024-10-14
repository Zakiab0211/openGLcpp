pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Zakiab0211/openGLcpp'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("openglcpp:latest")
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                script {
                    dockerImage.run('-d -p 8080:80')  // Adjust ports as needed
                }
            }
        }
    }
}


