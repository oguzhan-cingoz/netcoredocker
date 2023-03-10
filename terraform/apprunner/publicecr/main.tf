terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



resource "aws_apprunner_service" "ronesans-app-runner" {
  service_name = "ronesansapprunner"
  source_configuration {
    auto_deployments_enabled = false
    image_repository {
      image_identifier      = "public.ecr.aws/u3h5m1q5/ronesans-public-ecr:v1"
      image_repository_type = "ECR_PUBLIC"
      image_configuration {
        port = 80
      }
    }
  }
}