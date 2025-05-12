variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
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

variable "public_subnets" {
  description = "Lista de IDs de subredes públicas"
  type        = list(string)
}

variable "container_port" {
  description = "Puerto expuesto por el contenedor"
  type        = number
  default     = 8080
}

variable "container_cpu" {
  description = "CPU units para el contenedor (1024 = 1 CPU)"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memoria para el contenedor en MB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Número deseado de instancias del contenedor"
  type        = number
  default     = 2
}

variable "health_check_path" {
  description = "Path para el health check"
  type        = string
  default     = "/actuator/health"
}

variable "ecr_repository_url" {
  description = "URL del repositorio ECR"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN del secreto con las credenciales de la base de datos"
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

variable "ecs_security_group_id" {
  description = "ID del grupo de seguridad de ECS"
  type        = string
} 