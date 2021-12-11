data "vault_policy_document" "namespace" {
  rule {
    path         = "/namespace/*"
    capabilities = ["read", "list"]
    description  = "allow read, list kv"
  }
}

resource "vault_policy" "namespace" {
  name   = "namespace"
  policy = data.vault_policy_document.namespace.hcl
}
