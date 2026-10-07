resource "docker_image" "minio" {
  name = "cgr.dev/chainguard/minio:latest"
}

resource "docker_volume" "minio_data" {
  name = "data-platform-minio-data"
}

resource "docker_container" "minio" {
  name  = var.container_name
  image = docker_image.minio.image_id

  command = [
    "server",
    "/data",
    "--console-address",
    ":9001"
  ]

  env = [
    "MINIO_ROOT_USER=${var.minio_root_user}",
    "MINIO_ROOT_PASSWORD=${var.minio_root_password}"
  ]

  ports {
    internal = 9000
    external = var.minio_api_port
  }

  ports {
    internal = 9001
    external = var.minio_console_port
  }

  volumes {
    volume_name    = docker_volume.minio_data.name
    container_path = "/data"
  }

  networks_advanced {
    name = var.network_name
  }
}