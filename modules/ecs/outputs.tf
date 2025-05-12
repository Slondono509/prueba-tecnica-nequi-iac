output "ecs_cluster_id" {
  description = "ID del cluster ECS"
  value       = aws_ecs_cluster.main.id
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.main.name
}

output "alb_dns_name" {
  description = "DNS name del Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_security_group_id" {
  description = "ID del grupo de seguridad del ALB"
  value       = aws_security_group.alb.id
}

output "alb_listener_arn" {
  description = "ARN del listener del ALB"
  value       = aws_lb_listener.http.arn
} 