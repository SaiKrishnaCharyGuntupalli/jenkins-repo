pipeline {
    agent any  // Changed: Use any available agent on local machine
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code on local machine...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t fastapi-app .'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying FastAPI container...'
                sh '''
                    # Stop and remove old container
                    docker stop fastapi-backend || true
                    docker rm fastapi-backend || true
                    
                    # Run new container
                    docker run -d -p 8000:8000 --name fastapi-backend fastapi-app
                    
                    # Wait and verify
                    sleep 5
                    docker ps | grep fastapi-backend
                    
                    # Test the API from within the container network
                    docker exec fastapi-backend curl -f http://localhost:8000 || exit 1
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo '🚀 FastAPI running: http://localhost:8000'
            echo '📖 API docs: http://localhost:8000/docs'
        }
        failure {
            echo '❌ Pipeline failed!'
            sh 'docker logs fastapi-backend || true'
        }
    }
}
