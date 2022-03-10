terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}



resource "aws_apprunner_service" "ronesans-app-runner" {
  service_name = "ronesans-app-runner"
  source_configuration {
    authentication_configuration {
      access_role_arn = "arn:aws:iam::545579686143:role/service-role/ronesansAppRunnerECRAccessRole"
    }
    image_repository {
      image_identifier      = "545579686143.dkr.ecr.eu-west-1.amazonaws.com/ronesans_privateecr:21478"
      image_repository_type = "ECR"
      image_configuration {
        port = 80
      }
    }
  }
}