resource "null_resource" "acr_login" {
  provisioner "local-exec" {
    command = "az acr login --name ${azurerm_container_registry.acr.login_server}"
  }
}

# Use local-exec to push image to acr
# local-exec will work but use local-exec to change remote state is not a good practice
# - terraform can only manage local-exec id
# - terraform won't able to track state of acr image
# - use other image management tool like packer in stead of terraform.
resource "null_resource" "docker_push" {
  # https://www.terraform.io/docs/language/meta-arguments/for_each.html
  for_each = var.images

  provisioner "local-exec" {
    command = <<EOT
docker tag ${each.value} ${azurerm_container_registry.acr.login_server}/${each.value}
docker push ${azurerm_container_registry.acr.login_server}/${each.value}
EOT
  }
  depends_on = [
    null_resource.acr_login
  ]
}
