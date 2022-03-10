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

variable "apprunner-service-role" {
  description = "This role gives App Runner permission to access ECR"
  default     = "ronesans"
}

resource "aws_iam_role" "apprunner-service-role" {
  name               = "${var.apprunner-service-role}AppRunnerECRAccessRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.apprunner-service-assume-policy.json
}

data "aws_iam_policy_document" "apprunner-service-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "apprunner-service-role-attachment" {
  role       = aws_iam_role.apprunner-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}


resource "aws_iam_role" "apprunner-instance-role" {
  name = "${var.apprunner-service-role}AppRunnerInstanceRole"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.apprunner-instance-assume-policy.json
}

resource "aws_iam_policy" "Apprunner-policy" {
  name = "Apprunner-getSSM"
  policy = data.aws_iam_policy_document.apprunner-instance-role-policy.json
}

resource "aws_iam_role_policy_attachment" "apprunner-instance-role-attachment" {
  role = aws_iam_role.apprunner-instance-role.name
  policy_arn = aws_iam_policy.Apprunner-policy.arn
}

data "aws_iam_policy_document" "apprunner-instance-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["tasks.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_apprunner_service" "ronesans-app-runner" {
  service_name = "ronesans-app-runner"
  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner-service-role.name
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