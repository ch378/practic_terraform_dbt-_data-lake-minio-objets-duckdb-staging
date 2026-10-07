output "container_name" {
  description = "Redis container name"
  value       = docker_container.redis.name
}