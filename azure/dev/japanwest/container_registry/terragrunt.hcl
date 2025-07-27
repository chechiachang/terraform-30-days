# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../..//azure/modules/container_registry"
}

include {
  path = "${find_in_parent_folders()}"
}

inputs = {
  registry_name                 = "chechiajapanwest"
  location                      = "japanwest"
  public_network_access_enabled = true
}
