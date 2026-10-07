module "network" {
  source = "./modules/network"

  network_name = "${var.project_name}-network"
}

module "postgres" {
  source = "./modules/postgres"

  container_name  = "${var.project_name}-postgres"
  network_name    = module.network.network_name
  postgres_port   = var.postgres_port
  postgres_user   = var.postgres_user
  postgres_password = var.postgres_password
  postgres_database = var.postgres_database
}

module "redis" {
  source = "./modules/redis"

  container_name = "${var.project_name}-redis"
  network_name   = module.network.network_name
  redis_port     = var.redis_port
}

module "minio" {
  source = "./modules/minio"

  container_name      = "${var.project_name}-minio"
  network_name        = module.network.network_name
  minio_api_port      = var.minio_api_port
  minio_console_port  = var.minio_console_port
  minio_root_user     = var.minio_root_user
  minio_root_password = var.minio_root_password
}