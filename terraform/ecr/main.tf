resource "aws_ecr_repository" "ronesans-ecr" {
  name                 = "ronesans-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}