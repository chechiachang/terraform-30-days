resource "docker_container" "main" {
  for_each = var.containers

  name       = each.value.name
  image      = each.value.image
  command    = each.value.command
  env        = each.value.env
  privileged = each.value.privileged
  restart    = each.value.restart

  dynamic "ports" {
    for_each = each.value.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }
}
