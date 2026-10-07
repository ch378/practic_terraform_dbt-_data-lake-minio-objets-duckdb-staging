output "network_name" {
  description = "Docker network name"
  value       = module.network.network_name
}

output "postgres_container" {
  description = "PostgreSQL container name"
  value       = module.postgres.container_name
}

output "postgres_connection" {
  description = "PostgreSQL connection"
  value       = "localhost:${var.postgres_port}"
}

output "redis_container" {
  description = "Redis container name"
  value       = module.redis.container_name
}

output "redis_connection" {
  description = "Redis connection"
  value       = "localhost:${var.redis_port}"
}

output "minio_container" {
  description = "MinIO container name"
  value       = module.minio.container_name
}

output "minio_api" {
  description = "MinIO API"
  value       = "http://localhost:${var.minio_api_port}"
}

output "minio_console" {
  description = "MinIO Console"
  value       = "http://localhost:${var.minio_console_port}"
}