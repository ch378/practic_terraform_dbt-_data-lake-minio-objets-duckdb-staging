variable "container_name" {
  description = "PostgreSQL container name"
  type        = string
}

variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "postgres_port" {
  description = "PostgreSQL exposed port"
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
  description = "PostgreSQL database"
  type        = string
}