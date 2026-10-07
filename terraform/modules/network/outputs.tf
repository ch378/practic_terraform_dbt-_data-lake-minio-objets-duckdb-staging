output "network_name" {
  description = "Docker network name"
  value       = docker_network.data_network.name
}