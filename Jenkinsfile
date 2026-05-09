pipeline {
  agent any
  parameters {
    string(name: 'AWS_REGION', defaultValue: 'us-east-1')
    string(name: 'INSTANCE_TYPE', defaultValue: 't2.micro')
  }
  stages {
    stage('Terraform Init') {
      steps { sh 'terraform init' }
    }
    stage('Terraform Apply') {
      steps {
        sh """
          terraform apply -auto-approve \
            -var="aws_region=${params.AWS_REGION}"
        """
      }
    }
  }
  post {
    always {
      sh 'terraform output'
    }
  }
}
