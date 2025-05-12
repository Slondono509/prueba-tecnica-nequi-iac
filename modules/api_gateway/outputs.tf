output "api_endpoint" {
  description = "Endpoint de la API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "api_stage_url" {
  description = "URL del stage de la API Gateway"
  value       = aws_apigatewayv2_stage.main.invoke_url
} 