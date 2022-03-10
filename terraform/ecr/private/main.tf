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

resource "aws_ecr_repository" "ronesans_privateecr" {
  name                 = "ronesans_privateecr"
  image_scanning_configuration {
    scan_on_push = true
  }
}