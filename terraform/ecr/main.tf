terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_ecrpublic_repository" "ronesans-public-ecr" {
  provider = aws.us_east_1

  repository_name = "ronesans-public-ecr"

}