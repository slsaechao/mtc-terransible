terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
  shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
  # shared_config_files      = ["/Users/tf_user/.aws/conf"]
  # shared_credentials_files = ["/Users/tf_user/.aws/creds"]
  # profile                  = "customprofile"  
}

# provider "aws" {
#   region = "us-west-1"
#   shared_config_files = ["/Users/tf_user/.aws/conf"]
#   shared_credentials_files = ["/Users/tf_user/.aws/creds"]
#   profile = "customprofile"
# }

