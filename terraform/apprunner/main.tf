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

resource "aws_apprunner_service" "ronesans-apprunner" {
  service_name = "ronesans-apprunner"
  source_configuration {
    image_repository {
      image_identifier      = "545579686143.dkr.ecr.eu-west-1.amazonaws.com/ronesans-ecr:309"
      image_repository_type = "ECR"
      image_configuration {
        port = 5001
      }
    }
  }
}