terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
  }

  backend "s3" {
    bucket         = "81s-maha-remote-state-dev"
    key            = "expense-eks"
    region         = "us-east-1"
    dynamodb_table = "81s-locking"
  }
}

provider "aws" {
  region = "us-east-1"
}