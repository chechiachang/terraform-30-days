module "docker_image" {
  source = "../../..//utils/modules/docker"

  images = var.images
}
