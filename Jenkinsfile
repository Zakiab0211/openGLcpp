// pipeline {
//     agent any
//     stages {
//         stage('Clone Repository') {
//             steps {
//                 git 'https://github.com/Zakiab0211/openGLcpp'
//             }
//         }
//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     dockerImage = docker.build("openglcpp:latest")
//                 }
//             }
//         }
//         stage('Run Docker Container') {
//             steps {
//                 script {
//                     dockerImage.run('-d -p 8080:80')  // Adjust ports as needed
//                 }
//             }
//         }
//     }
// }

// iki percobaan
pipeline {
    agent any

    environment {
        // Set the Docker credentials ID for pushing images to the registry
        DOCKER_CRED_ID = 'cb5ed91a-ee37-4f8d-9e62-cc78c6a36157'  // Replace with your actual Docker credentials ID
    }

    stages {
        stage('Git Checkout') {
            steps {
                // Clone the GitHub repository without changelog or polling
                //git url: 'https://github.com/Zakiab0211/openGLcpp.git', changelog: false, poll: false
                git url: 'https://github.com/Zakiab0211/openGLcpp.git', branch: 'main', changelog: false, poll: false

            }
        }

        stage('Docker Setup') {
            steps {
                script {
                    // Add Jenkins user to the Docker group and set permissions on the Docker socket
                    // Note: These commands may require Jenkins to be restarted for group changes to apply
                    sh 'sudo usermod -aG docker jenkins || true'
                    sh 'sudo chown jenkins:docker /var/run/docker.sock || true'

                    // Setup Docker Buildx for multi-architecture builds
                    sh 'make buildx-setup'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    // Use Docker credentials to login to the registry and push the images
                    withDockerRegistry(credentialsId: DOCKER_CRED_ID) {
                        sh 'make buildx-push'
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean the workspace to ensure there are no leftover files
            cleanWs()
        }
        success {
            // Echo a success message if the pipeline completes successfully
            echo 'Pipeline succeeded! Images built and pushed successfully.'
        }
        failure {
            // Echo a failure message if any step fails
            echo 'Pipeline failed! Check the logs for details.'
        }
    }
}
