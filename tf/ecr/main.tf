resource "aws_ecr_repository" "registry" {
  name = "lambda-function-demo-image"
  force_delete = true
}

output "repository_url" {
  value = aws_ecr_repository.registry.repository_url
}