pipeline {
  agent any

  environment {
    PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
  }

  parameters {
    string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS Region')
    string(name: 'INSTANCE_TYPE', defaultValue: 't3.micro', description: 'EC2 Instance Type')
  }

  stages {
    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }
    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -var="aws_region=${AWS_REGION}"'
      }
    }
    stage('Terraform Apply') {
      steps {
        sh '''
          terraform apply -auto-approve \
            -var="aws_region=${AWS_REGION}"
        '''
      }
    }
  }

  post {
    always {
      sh 'terraform output || true'
    }
  }
}
