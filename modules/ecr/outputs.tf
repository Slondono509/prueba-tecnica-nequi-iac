output "repository_url" {
  description = "URL del repositorio ECR"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_name" {
  description = "Nombre del repositorio ECR"
  value       = aws_ecr_repository.main.name
} 