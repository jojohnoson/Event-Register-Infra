pipeline {
    agent any

    environment {
        TF_VAR_region          = 'ap-south-1'
        TF_VAR_vpc_cidr        = '10.0.0.0/16'
        TF_VAR_root_sub1_cidr  = '10.0.1.0/24'
        TF_VAR_root_sub2_cidr  = '10.0.2.0/24'
        TF_VAR_root_sub1_az    = 'ap-south-1a'
        TF_VAR_root_sub2_az    = 'ap-south-1b'
        TF_VAR_server_1        = 't2.micro'
        TF_VAR_server_2        = 't2.micro'
        TF_VAR_key_access      = 'mypassword'
    }

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
                withCredentials([
                    string(credentialsId: 'aws-credentials-usr', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-credentials-pwd', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'aws-default-region', variable: 'AWS_DEFAULT_REGION')
                ]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Format & Validate') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-credentials-usr', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-credentials-pwd', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'aws-default-region', variable: 'AWS_DEFAULT_REGION')
                ]) {
                    sh 'terraform fmt'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-credentials-usr', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-credentials-pwd', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'aws-default-region', variable: 'AWS_DEFAULT_REGION')
                ]) {
                    sh 'rm -f terraformstate.txt tfplan'
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform show -no-color tfplan > terraformstate.txt'
                }
            }
        }

        stage('Approval Gate') {
            steps {
                input message: 'Inspect terraformstate.txt in workspace. Approve deployment to AWS?', ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-credentials-usr', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-credentials-pwd', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'aws-default-region', variable: 'AWS_DEFAULT_REGION')
                ]) {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }

    post {
        always {
            sh 'rm -f tfplan terraformstate.txt'
        }
    }
}