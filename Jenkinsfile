pipeline {
  agent any
  environment {
    TF_IN_AUTOMATION = 'true'
    TF_CLI_CONFIG_FILE = credentials('tf-cred')
    AWS_SHARED_CREDENTIALS_FILE='/home/ubuntu/.aws/credentials'
  }
  stages {
    stage('Init') {
      steps {
        sh 'ls'
        sh 'terraform init -no-color'
      }
    }
    stage('Plan') {
      steps {
        sh 'terraform plan -no-color'
      }
    }
    stage('Validate Apply') {
      input {
        message "Do you want to apply this play?"
        ok "Apply this plan."
      }
      steps {
        echo 'Apply Accepted'
      }
    }
    stage('Apply') {
      steps {
        sh 'terraform apply -auto-approve -no-color -var-file="test.tfvars"'
      }
    }
    stage('Ec2 Wait') {
      steps {
        sh 'aws ec2 wait instance-status-ok --region us-west-1'
      }
    }
    stage('Validate Ansible main-playbook') {
      input {
        message "Do you want to run main-playbook.yml to install Grafana and Prometheus?"
        ok "Let's run main-playbook.yml."
      }
      steps {
        echo 'Running main-playbook.yml to install Grafana and Prometheus.'
      }
    }
    stage('Ansible') {
      steps {
        ansiblePlaybook(credentialsId: 'ec2-ssh-key', inventory: 'aws_hosts', playbook: 'playbooks/main-playbook.yml')
      }
    }
    stage('Validate Destroy') {
      input {
        message "Do you want to run terraform destroy?"
        ok "Run terraform destroy."
      }
      steps {
        echo 'Running terraform destroy'
      }
    }
    stage('Destroy') {
      steps {
        sh 'terraform destroy -auto-approve -no-color'
      }
    }
  }
  post {
    success {
      echo 'Success!'
    }
    failure {
    sh 'terraform destroy -auto-approve -no-color
    }
  }
}