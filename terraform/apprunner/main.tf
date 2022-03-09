terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

resource "aws_iam_role" "role" {
   name = "ronesans-apprunner-role"
   assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
           "build.apprunner.amazonaws.com",
           "tasks.apprunner.amazonaws.com"
         ]
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ronesans-policy-attach" {
   role       = aws_iam_role.role.name
   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
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
        
      }
      image_identifier      = "545579686143.dkr.ecr.eu-west-1.amazonaws.com/ronesans-ecr:309"
      image_repository_type = "ECR"
    }
    authentication_configuration{
      access_role_arn = aws_iam_role.role.arn
    }
    auto_deployments_enabled = true
  }

  tags = {
    Name = "ronesans-poc"
  }
}
