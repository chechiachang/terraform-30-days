resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  # https://www.terraform.io/docs/language/functions/merge.html
  tags     = merge(
    var.extra_tags,
    {
      managed-by  = "terraform"
    }
  )
}
