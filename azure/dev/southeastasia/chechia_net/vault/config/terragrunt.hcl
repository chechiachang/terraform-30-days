# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../../../..//vault/modules/kubernetes_auth"
}

include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency
dependency "network" {
  config_path = find_in_parent_folders("azure/foundation/compute_network")
}

inputs = {
  location    = local.common.location
  environment = local.common.environment

  kubeconfig_file = "~/.kube/azure-aks"
}
