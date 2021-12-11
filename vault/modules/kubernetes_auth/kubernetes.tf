module "auth_kubernetes" {
  source = "../auth_methods/kubernetes"

  kubeconfig_file = var.kubeconfig_file
  environment = var.environment
}
