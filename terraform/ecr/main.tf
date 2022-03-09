terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

resource "aws_ecrpublic_repository" "ronesans-ecr-public2" {
  provider = aws.us-west-2

  repository_name = "ronesans-ecr-public2"
}