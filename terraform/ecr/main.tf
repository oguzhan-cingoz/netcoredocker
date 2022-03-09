terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1"
}

resource "aws_ecrpublic_repository" "ronesans-public-ecr" {
  provider = aws.eu_west_1

  repository_name = "ronesans-public-ecr"

}