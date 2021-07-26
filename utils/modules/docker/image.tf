# data of (remote) docker image
data "docker_registry_image" "main" {
  for_each = var.images

  name = each.value
}

# resource of local docker image
resource "docker_image" "main" {
  for_each      = var.images

  name          = data.docker_registry_image.main[each.key].name
  # Pull image if sha256 changed in data of (remote) docker image
  pull_triggers = [data.docker_registry_image.main[each.key].sha256_digest]
}
