pipeline {
    agent any

    environment {
        IMAGE_NAME = "fastapi-app"
        CONTAINER_NAME = "fastapi-container"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/SaiKrishnaCharyGuntupalli/jenkins-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${IMAGE_NAME} .'
                }
            }
        }

        stage('Stop and Remove Old Container') {
            steps {
                script {
                    sh '''
                    docker ps -q --filter "name=${CONTAINER_NAME}" | grep -q . && docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    '''
                }
            }
        }

        stage('Run New Container') {
            steps {
                script {
                    sh 'docker run -d -p 8000:8000 --name ${CONTAINER_NAME} ${IMAGE_NAME}'
                }
            }
        }
    }

    post {
        success {
            echo '🎉 FastAPI App deployed successfully!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
