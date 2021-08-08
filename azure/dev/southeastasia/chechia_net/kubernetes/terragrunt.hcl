# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../../..//azure/modules/kubernetes_cluster"
}

include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency
dependency "network"{
  config_path = find_in_parent_folders("azure/foundation/compute_network")
}

inputs = {
  location    = local.common.location
  environment = local.common.environment

  kubernetes_cluster_name = "terraform-30-days"
  default_node_pool_vm_size = "Standard_D2_v2" # This is beyond 12 months free quota
  default_node_pool_count = 1

  network = dependency.network.outputs.vnet_name # acctvnet
  subnet  = dependency.network.outputs.vnet_subnets[2] # dev-3

  # Generate local kubeconfig file
  kubeconfig_output_path = pathexpand("~/.kube/azure-aks-terraform-30-days")

  # Additional node pool

  spot_node_pools = {
    spot = {
      name       = "spot"
      vm_size    = "Standard_D2_v2"
      node_count = 1
      mode       = "User"

      # Spot config
      priority = "Spot"
      eviction_policy = "Delete"
      spot_max_price = -1 # Default on-demand price
      node_labels = {
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
      #  "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
    }
  }

}
