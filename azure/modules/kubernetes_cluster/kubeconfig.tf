resource "local_file" "kubeconfig" {
  filename = var.kubeconfig_output_path
  content  = azurerm_kubernetes_cluster.main.kube_config_raw
}
