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
resource "aws_ecrpublic_repository" "ronesans-ecr-public" {
  name = "ronesans-ecr-public"

  image_scanning_configuration {
    scan_on_push = true
  }
}