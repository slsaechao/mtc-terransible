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
        sh 'cat $BRANCH_NAME.tfvars'
        sh 'terraform init -no-color'
      }
    }
    stage('Plan') {
      steps {
        sh 'terraform plan -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
    }
    stage('Validate Apply') {
      when {
        beforeInput true
        branch "dev"
      }
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
        sh 'terraform apply -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
    }
    stage('Inventory') {
      steps {
        sh '''printf \\
          "\\n$(terraform output -json instance_ips | jq -r \'.[]\')" \\
          >> aws_hosts'''
      }
    }
    stage('EC2 Wait') {
      steps {
        sh '''aws ec2 wait instance-status-ok \\
            --instance-ids $(terraform output -json instance_ids | jq -r \'.[]\') \\
            --region us-west-1'''
      }
    }
    stage('Validate Ansible main-playbook') {
      when {
        beforeInput true
        branch "dev"
      }
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
    stage('Test Grafana and Prometheus') {
      steps {
        ansiblePlaybook(credentialsId: 'ec2-ssh-key', inventory: 'aws_hosts', playbook: 'playbooks/node-test.yml') 
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
        sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
    }
  }
  post {
      success {
          echo 'Success!'
      }
      failure {
          sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
      aborted {
          sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
  }
}