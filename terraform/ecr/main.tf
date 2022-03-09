terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

resource "aws_ecrpublic_repository" "ronesans-public-ecr" {
  provider = aws.us_west_2

  repository_name = "ronesans-public-ecr"
}