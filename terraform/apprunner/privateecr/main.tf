provider "aws" {
  region = "eu-west-1"
}

resource "aws_iam_role" "role" {
   name = "test-role"
   assume_role_policy = jsonencode( 
{
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


resource "aws_apprunner_service" "ngnix-apprunner-service-ecr" {
  service_name = "demo_apprunner"

  source_configuration {
    image_repository {
      image_configuration {
        port = "80"
      }
      image_identifier      = "545579686143.dkr.ecr.eu-west-1.amazonaws.com/ronesans_privateecr:21478"
      image_repository_type = "ECR"
    }
    authentication_configuration{
      access_role_arn = aws_iam_role.role.arn
    }
    auto_deployments_enabled = true
  }
  
  tags = {
    Name = "demo_apprunner"
  }
}