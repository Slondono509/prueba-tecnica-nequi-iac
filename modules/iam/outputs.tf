output "ecs_execution_role_arn" {
  description = "ARN del rol de ejecución de ECS"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN del rol de tarea de ECS"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_security_group_id" {
  description = "ID del grupo de seguridad de ECS"
  value       = aws_security_group.ecs.id
} 