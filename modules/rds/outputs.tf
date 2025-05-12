output "secret_arn" {
  description = "ARN del secreto que contiene las credenciales de RDS"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "db_instance_endpoint" {
  description = "Endpoint de la instancia RDS"
  value       = aws_db_instance.postgresql.endpoint
}

output "db_instance_name" {
  description = "Nombre de la base de datos"
  value       = aws_db_instance.postgresql.db_name
}

output "db_instance_port" {
  description = "Puerto de la base de datos"
  value       = 5432
} 