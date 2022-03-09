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
  repository_name = "ronesans-ecr-public"
}