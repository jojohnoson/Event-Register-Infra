pipeline {
    agent any

    environment {
        // References 'aws-credentials' stored in Jenkins Credentials Manager
        AWS_ACCESS_KEY_ID     = credentials('aws-credentials-usr')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials-pwd')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    triggers {
        // Listens for GitHub webhook push events
        githubPush()
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Format & Validate') {
            steps {
                sh 'terraform fmt -check'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Approval Gate') {
            steps {
                // Safety gate: Requires manual approval before changing live AWS infrastructure
                input message: 'Review the plan output above. Apply infrastructure changes to AWS?', ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        always {
            // Clean up binary plan files locally
            sh 'rm -f tfplan'
        }
    }
}