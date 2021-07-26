resource "docker_container" "main" {
  for_each = var.containers

  name  = each.value.name
  image = each.value.image
  entrypoint = each.value.entrypoint
}
