provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_role" "rronesansroles" {
  name = "rronesansroles"

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

resource "aws_iam_role_policy_attachment" "rronesansrolespolicy" {
  role = aws_iam_role.rronesansroles.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_apprunner_service" "ronesans-app-runner" {
  depends_on = [aws_iam_role.rronesansroles]
  service_name = "ronesans-app-runner"
  source_configuration {
    authentication_configuration {
      access_role_arn = "${aws_iam_role.rronesansroles.arn}"
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