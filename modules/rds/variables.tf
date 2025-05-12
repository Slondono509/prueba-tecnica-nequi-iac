variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue (dev, qa, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs de subredes privadas"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "ID del grupo de seguridad de ECS"
  type        = string
}

variable "db_username" {
  description = "Usuario de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Contraseña de la base de datos"
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "ARN del rol de ejecución de ECS"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ARN del rol de tarea de ECS"
  type        = string
} 