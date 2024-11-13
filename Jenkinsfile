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
        DISPLAY = ':0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Add your test commands here
                    sh 'docker run --rm ${DOCKER_IMAGE} make test'
                }
            }
        }
        
        stage('Run') {
            steps {
                script {
                    // Run the application
                    sh '''
                        docker run -d \
                        -e DISPLAY=${DISPLAY} \
                        -v /tmp/.X11-unix:/tmp/.X11-unix \
                        --network host \
                        ${DOCKER_IMAGE}
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Clean up
            sh 'docker system prune -f'
        }
    }
}
