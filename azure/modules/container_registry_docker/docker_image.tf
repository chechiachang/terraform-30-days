module "docker_image" {
  source = "../../..//localhost/modules/docker"

  images = var.images
}
