output "container_name" {
  description = "PostgreSQL container name"
  value       = docker_container.postgres.name
}