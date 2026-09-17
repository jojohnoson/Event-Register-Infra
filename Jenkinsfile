pipeline {
    agent any

    environment {
        // AWS Credentials retrieved securely from Jenkins Credentials Manager
        AWS_ACCESS_KEY_ID     = credentials('aws-credentials-usr')
        AWS_SECRET_ACCESS_KEY = credentials('aws-credentials-pwd')
        
        // AWS Region stored in Jenkins Secret Text ID 'aws-default-region' (value: ap-south-1)
        AWS_DEFAULT_REGION    = credentials('aws-default-region')

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
                // Initializes modules and S3 backend non-interactively
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform Format & Validate') {
            steps {
                // Automatically formats files and validates syntax
                sh 'terraform fmt'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Remove previous plan summaries before generating a new run
                sh 'rm -f terraformstate.txt tfplan'

                // Generates binary execution plan
                sh 'terraform plan -input=false -out=tfplan'
                
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