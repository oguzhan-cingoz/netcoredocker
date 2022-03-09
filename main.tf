provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ronesans-poc" {
    ami           = "ami-0d527b8c289b4af7f" # eu-central-1
    instance_type = "t2.micro"
}