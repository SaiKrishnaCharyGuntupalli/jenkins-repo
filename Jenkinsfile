pipeline {
    agent none
    
    stages {
        stage('Checkout') {
            agent { label 'ec2-production' }
            steps {
                echo '📥 Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Setup Environment') {
            agent { label 'ec2-production' }
            steps {
                echo '🔧 Setting up Python virtual environment...'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Test Installation') {
            agent { label 'ec2-production' }
            steps {
                echo '🧪 Testing dependencies...'
                sh '''
                    . venv/bin/activate
                    python --version
                    pip list
                    python -c "import fastapi; import uvicorn; print('✅ All dependencies installed')"
                '''
            }
        }
        
        stage('Deploy to EC2') {
            agent { label 'ec2-production' }
            steps {
                echo '🚀 Deploying FastAPI application...'
                sh '''
                    # Restart the systemd service
                    sudo systemctl restart fastapi
                    
                    # Wait for service to start
                    sleep 3
                    
                    # Verify service is running
                    if sudo systemctl is-active --quiet fastapi; then
                        echo "✅ Service is running"
                    else
                        echo "❌ Service failed to start"
                        sudo systemctl status fastapi
                        exit 1
                    fi
                    
                    # Test the API endpoint
                    if curl -f http://localhost:8000 > /dev/null 2>&1; then
                        echo "✅ API is responding"
                    else
                        echo "❌ API is not responding"
                        exit 1
                    fi
                    
                    echo ""
                    echo "=========================================="
                    echo "✅ DEPLOYMENT SUCCESSFUL!"
                    echo "=========================================="
                    echo "🌐 Application URL: http://13.203.105.40:8000"
                    echo "📖 API Documentation: http://13.203.105.40:8000/docs"
                    echo "=========================================="
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline completed successfully!'
            echo '🚀 FastAPI is running at: http://13.203.105.40:8000'
            echo '📖 API Docs: http://13.203.105.40:8000/docs'
        }
        failure {
            echo '❌ Pipeline failed!'
            echo '🔍 Check logs with: sudo journalctl -u fastapi -n 50'
        }
        always {
            echo '📊 Build finished at: ' + new Date().toString()
        }
    }
}
