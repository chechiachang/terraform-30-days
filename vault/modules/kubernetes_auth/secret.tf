resource "vault_mount" "namespace" {
  path        = "namespace"
  type        = "kv-v2"
  description = "This is an example KV Version 2 secret engine mount"
}
