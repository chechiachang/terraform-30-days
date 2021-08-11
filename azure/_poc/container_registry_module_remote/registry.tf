locals {
  location            = "southeastasia"
  environments        = ["dev", "stag", "prod"]
  resource_group_name = "terraform-30-days-poc"
}

module "test" {
  source = "git::ssh://git@github.com/chechiachang/terraform-30-days.git//azure/modules/container_registry?ref=v0.0.1"

  registry_name                 = "chechiatest"
  resource_group_name           = local.resource_group_name
  location                      = local.location
  public_network_access_enabled = true
}

module "registry" {
  for_each = toset(local.environments) # convert tuple to set of string

  source = "git::ssh://git@github.com/chechiachang/terraform-30-days.git//azure/modules/container_registry?ref=v0.0.1"

  registry_name                 = "chechia${each.value}"
  resource_group_name           = local.resource_group_name
  location                      = local.location
  public_network_access_enabled = true
}
