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



resource "aws_iam_role" "role" {
   name = "test-role"
   assume_role_policy = jsonencode({
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": [
           "build.apprunner.amazonaws.com",
           "tasks.apprunner.amazonaws.com"
         ]
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 } )
}
resource "aws_iam_role_policy_attachment" "test-attach" {
   role       = aws_iam_role.role.name
   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
 }

resource "aws_apprunner_service" "ronesans-apprunner" {
  service_name = "ronesans-apprunner"
  source_configuration {
    authentication_configuration{
      access_role_arn = aws_iam_role.role.arn
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