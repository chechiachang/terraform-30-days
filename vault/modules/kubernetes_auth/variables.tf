variable "environment" {
  type = string
}

variable "kubeconfig_file" {
  type    = string
  default = "~/.kube/azure-aks"
}
