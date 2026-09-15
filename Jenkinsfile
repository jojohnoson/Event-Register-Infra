pipeline {
    agent any

    environment {
        // AWS Credentials retrieved securely from Jenkins Credentials Manager
        AWS_ACCESS_KEY_ID     = credentials('aws-credentials-usr')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials-pwd')
        
        // AWS Region stored in Jenkins Secret Text ID 'aws-default-region' (value: ap-south-1)
        AWS_DEFAULT_REGION    = credentials('aws-default-region')
    }

    triggers {
        // Listens for incoming GitHub Webhook events
        githubPush()
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clones the repo code into the Jenkins build workspace
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                // Initializes modules and S3 backend
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
                // Remove previous plan summaries before generating a new run
                sh 'rm -f terraformstate.txt tfplan'

                // Generates binary execution plan
                sh 'terraform plan -out=tfplan'
                
                // Overwrites terraformstate.txt with ONLY the latest plan output
                sh 'terraform show -no-color tfplan > terraformstate.txt'
            }
        }

        stage('Approval Gate') {
            steps {
                // Production Gate: Pauses execution until manually approved in Jenkins UI
                input message: 'Inspect terraformstate.txt in workspace. Approve deployment to AWS?', ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Applies the exact approved plan file
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        always {
            // Cleans up all local temporary plan artifacts post-run
            sh 'rm -f tfplan terraformstate.txt'
        }
    }
}