variable "container_name" {
  description = "Redis container name"
  type        = string
}

variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "redis_port" {
  description = "Redis exposed port"
  type        = number
}