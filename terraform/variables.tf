variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "postgres_port" {
  description = "PostgreSQL exposed port"
  type        = number
}

variable "redis_port" {
  description = "Redis exposed port"
  type        = number
}

variable "minio_api_port" {
  description = "MinIO API exposed port"
  type        = number
}

variable "minio_console_port" {
  description = "MinIO Console exposed port"
  type        = number
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
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