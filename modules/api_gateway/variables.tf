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

variable "alb_listener_arn" {
  description = "ARN del listener del ALB"
  type        = string
} 