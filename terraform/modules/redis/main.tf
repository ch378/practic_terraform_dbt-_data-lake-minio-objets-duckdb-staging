resource "docker_image" "redis" {
  name = "redis:7"
}

resource "docker_volume" "redis_data" {
  name = "data-platform-redis-data"
}

resource "docker_container" "redis" {
  name  = var.container_name
  image = docker_image.redis.image_id

  ports {
    internal = 6379
    external = var.redis_port
  }

  volumes {
    volume_name    = docker_volume.redis_data.name
    container_path = "/data"
  }

  networks_advanced {
    name = var.network_name
  }
}