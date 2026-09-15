pipeline {
    agent any

    environment {
        APP_NAME        = 'infra-project-app'
        DOCKER_REGISTRY = 'your-dockerhub-username' // Replace with your Docker Hub username
        IMAGE_NAME      = "${DOCKER_REGISTRY}/${APP_NAME}"
        IMAGE_TAG       = "${BUILD_NUMBER}"
        AWS_REGION      = 'us-east-1' // Replace with your AWS Region
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Ensure your SonarQube server is configured in Jenkins System Settings as 'SonarQube'
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        sonar-scanner \
                          -Dsonar.projectKey=${APP_NAME} \
                          -Dsonar.sources=src \
                          -Dsonar.exclusions=**/node_modules/**,.next/** \
                          -Dsonar.sourceEncoding=UTF-8
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    // Pauses pipeline until SonarQube analysis quality gate passes
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                    // Builds the image using the Dockerfile located inside the src directory
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -t ${IMAGE_NAME}:latest -f src/Dockerfile ."
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                // Scans the container image for vulnerabilities before pushing
                sh "trivy image --severity HIGH,CRITICAL ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Push Image to Registry') {
            steps {
                script {
                    // Requires 'dockerhub-credentials' defined in Jenkins Credentials Manager (Username/Password)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                        sh "docker push ${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    echo "Deploying container version ${IMAGE_TAG}..."
                    // Injects runtime secrets dynamically instead of storing them in source control
                    withCredentials([string(credentialsId: 'app-db-password', variable: 'DB_PASSWORD')]) {
                        sh """
                            docker stop ${APP_NAME} || true
                            docker rm ${APP_NAME} || true
                            docker run -d \
                              --name ${APP_NAME} \
                              -p 3000:3000 \
                              -e NODE_ENV=production \
                              -e DB_PASSWORD=\${DB_PASSWORD} \
                              --restart unless-stopped \
                              ${IMAGE_NAME}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up old workspace files and untag local docker images to save disk space
            sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
            cleanWs()
        }
        success {
            echo "Pipeline executed successfully and application deployed!"
        }
        failure {
            echo "Pipeline failed. Check stage logs for details."
        }
    }
}