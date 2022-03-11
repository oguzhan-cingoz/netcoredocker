provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_role" "ronesansrroles" {
  name = "ronesansrroles"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "build.apprunner.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "ronesansrrolespolicy" {
  role = aws_iam_role.ronesansrroles.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

variable "arn" {
  arnid=aws_iam_role.ronesansrroles.arn
}
resource "aws_apprunner_service" "ronesans-app-runnerr" {
  service_name = "ronesans-app-runnerr"
  source_configuration {
    authentication_configuration {
      access_role_arn = var.arn.arnid
    }
    image_repository {
      image_identifier      = "545579686143.dkr.ecr.eu-west-1.amazonaws.com/ronesans_privateecr:21478"
      image_repository_type = "ECR"
      image_configuration {
        port = 80
      }
    }
  }
}