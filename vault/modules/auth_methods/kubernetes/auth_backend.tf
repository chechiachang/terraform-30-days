resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "${var.environment}-kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "main" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = local.kubeconfig.clusters[0].cluster.server
  kubernetes_ca_cert     = data.kubernetes_secret.vault_auth.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.vault_auth.data["token"]
  issuer                 = "api"
  disable_iss_validation = "true"
}
