output "container_name" {
  description = "MinIO container name"
  value       = docker_container.minio.name
}

output "api_port" {
  description = "MinIO API port"
  value       = var.minio_api_port
}

output "console_port" {
  description = "MinIO Console port"
  value       = var.minio_console_port
}