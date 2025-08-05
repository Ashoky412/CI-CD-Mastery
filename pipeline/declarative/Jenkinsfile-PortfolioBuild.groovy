pipeline {
    agent {
        kubernetes {
            label 'k8s-agent'
            defaultContainer 'jnlp'
        }
    }

    environment {
        IMAGE_NAME = "ashoky412/ashok-portfolio"
        TAG = "v1.0"
        REGISTRY = "docker.io"
    }

    stages {
        stage('Clone Code') {
            steps {
                git url: 'https://github.com/Ashoky412/ashok-portfolio.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh 'chmod +x scripts/build.sh && scripts/build.sh'
            }
        }

        stage('Unit Test') {
            steps {
                sh 'chmod +x scripts/unit-test.sh && scripts/unit-test.sh'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $REGISTRY/$IMAGE_NAME:$TAG .'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-token', variable: 'DOCKER_TOKEN')]) {
                    sh """
                    echo $DOCKER_TOKEN | docker login -u ashoky412 --password-stdin
                    docker push $REGISTRY/$IMAGE_NAME:$TAG
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Portfolio build & push pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs."
        }
    }
}
