variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, qa, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "nequi-prueba"
}

variable "db_username" {
  description = "Usuario de la base de datos PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Contraseña de la base de datos PostgreSQL"
  type        = string
  sensitive   = true
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
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

variable "tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "nequi-prueba"
    ManagedBy   = "terraform"
  }
} 