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
locals {
  ecr_repository_name = "hello-world-ronesans"
  service_name        = "hello-world-ronesans"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_ecr_repository" "ecr_repository" {
  name = local.ecr_repository_name
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  repository = aws_ecr_repository.ecr_repository.name
  policy     = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Expire untagged images older than 14 days",
        "selection" : {
          "tagStatus" : "untagged",
          "countType" : "sinceImagePushed",
          "countUnit" : "days",
          "countNumber" : 14
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}

resource "aws_iam_role" "runner_role" {
  name               = "${local.service_name}-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "runner_role_policy_attachment" {
  role       = aws_iam_role.runner_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_apprunner_service" "runner_service" {
  service_name = local.service_name
  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.runner_role.arn
    }
    image_repository {
      image_identifier      = "545579686143.dkr.ecr.eu-west-1.amazonaws.com/ronesans-ecr:309"
      image_repository_type = "ECR"
      image_configuration {
        port = 5001
      }
    }
  }
}

output "service_url" {
  value = aws_apprunner_service.runner_service.service_url
}
