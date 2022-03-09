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

resource "aws_apprunner_service" "ronesans-poc" {
  service_name = "ronesans-poc"

  source_configuration {
    image_repository {
      image_configuration {
        port = 5001
        
      }
      image_identifier      = "545579686143.dkr.ecr.eu-west-1.amazonaws.com/ronesans-ecr:309"
      image_repository_type = "ECR"
    }
  }

  tags = {
    Name = "ronesans-poc"
  }
}
