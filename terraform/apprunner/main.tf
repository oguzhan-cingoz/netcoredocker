terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "ronesansacrrole" {
  name               = "ronesansacrrole"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Resource = [
                "arn:aws:iam::aws:role/my-role",
                "arn:aws:iam::aws:role/service-role/AppRunnerECRAccessRole"
            ]
        Effect    = "Allow"
        Principal = {
          Service = [ 
            "build.apprunner.amazonaws.com",
            "tasks.apprunner.amazonaws.com"
          ]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ronesansacrrole_policy_attachment" {
  role       = aws_iam_role.ronesansacrrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerFullAccess"
}

resource "aws_apprunner_service" "ronesans-app-runner" {
  service_name = "ronesans-app-runner"
  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.ronesansacrrole.arn
    }
    image_repository {
      image_identifier      = "public.ecr.aws/u3h5m1q5/ronesans-public-ecr:v1"
      image_repository_type = "ECR_PUBLIC"
      image_configuration {
        port = 5001
      }
    }
  }
}