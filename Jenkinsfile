pipeline {
    agent any

    triggers {
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
                sh 'terraform fmt'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'rm -f terraformstate.txt tfplan'
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan > terraformstate.txt'
            }
        }

        stage('Approval Gate') {
            steps {
                input message: 'Inspect terraformstate.txt in workspace. Approve deployment to AWS?', ok: 'Deploy'
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
            sh 'rm -f tfplan terraformstate.txt'
        }
    }
}