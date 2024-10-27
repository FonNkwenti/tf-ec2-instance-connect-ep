
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        # version = "5.14.0"
    }
  }
}

provider "aws" {
    alias = "service_provider"
    region = "eu-west-1"
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "default"
    default_tags {
      tags = {
        use_case = "terraform tutorial"
      }
    }
}