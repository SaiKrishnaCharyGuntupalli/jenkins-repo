pipeline {
    agent none
    
    stages {
        stage('Checkout') {
            agent { label 'ec2-production' }
            steps {
                echo 'Checking out code on EC2...'
                checkout scm
            }
        }
        
        stage('Setup Python Environment') {
            agent { label 'ec2-production' }
            steps {
                echo 'Setting up Python on EC2...'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                '''
            }
        }
        
        stage('Install Dependencies') {
            agent { label 'ec2-production' }
            steps {
                echo 'Installing dependencies on EC2...'
                sh '''
                    . venv/bin/activate
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Test') {
            agent { label 'ec2-production' }
            steps {
                echo 'Running tests on EC2...'
                sh '''
                    . venv/bin/activate
                    python --version
                    pip list
                '''
            }
        }
        
        stage('Stop Existing App') {
            agent { label 'ec2-production' }
            steps {
                echo 'Stopping existing FastAPI on EC2...'
                sh '''
                    pkill -f "uvicorn main:app" || true
                    sleep 2
                '''
            }
        }
        
        stage('Deploy to EC2') {
            agent { label 'ec2-production' }
            steps {
                echo 'Deploying FastAPI to EC2...'
                sh '''
                    . venv/bin/activate
                    
                    nohup uvicorn main:app --host 0.0.0.0 --port 8000 > fastapi.log 2>&1 &
                    echo $! > fastapi.pid
                    
                    sleep 5
                    
                    curl -f http://localhost:8000 || exit 1
                    
                    echo "✅ Deployed successfully on EC2!"
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo '🚀 FastAPI running on EC2: http://13.127.203.26:8000'
            echo '📖 API docs: http://13.127.203.26:8000/docs'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
