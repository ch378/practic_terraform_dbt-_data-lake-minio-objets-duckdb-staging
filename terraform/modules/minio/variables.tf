variable "container_name" {
  description = "MinIO container name"
  type        = string
}

variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "minio_api_port" {
  description = "MinIO API port"
  type        = number
}

variable "minio_console_port" {
  description = "MinIO Console port"
  type        = number
}

variable "minio_root_user" {
  description = "MinIO root username"
  type        = string
}

variable "minio_root_password" {
  description = "MinIO root password"
  type        = string
  sensitive   = true
}