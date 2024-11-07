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
        DOCKER_IMAGE = 'opengl-cpp-app'
        DOCKER_TAG = 'latest'
        GITHUB_REPO = 'https://github.com/Zakiab0211/openGLcpp.git'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub
                git branch: 'main', url: env.GITHUB_REPO
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh '''
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    '''
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // Run tests inside Docker container
                    sh '''
                        docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} make test
                    '''
                }
            }
        }
        
        stage('Run Application') {
            steps {
                script {
                    // Run the OpenGL application with X11 forwarding
                    sh '''
                        docker run --rm \
                            -e DISPLAY=${DISPLAY} \
                            -v /tmp/.X11-unix:/tmp/.X11-unix \
                            --device /dev/dri:/dev/dri \
                            ${DOCKER_IMAGE}:${DOCKER_TAG} make run
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Clean up Docker images
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check the logs for details.'
        }
    }
}
