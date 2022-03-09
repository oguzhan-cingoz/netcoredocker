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
        runtime_environment_variables = {
          "DOCKER_REGISTRY_SERVER_URL" = "https://ronesans.azurecr.io",
          "DOCKER_REGISTRY_SERVER_USERNAME" = "ronesans",
          "DOCKER_REGISTRY_SERVER_PASSWORD" = "k6JhIU/JrtqkLbDuidje/U9WyJVDg7eH"
        }
      }
      image_identifier      = "ronesans.azurecr.io/ronesans:306"
      image_repository_type = "ECR_PUBLIC"
    }
  }

  tags = {
    Name = "ronesans-poc"
  }
}
