# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../..//utils/modules/docker"
}

include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs = {

  containers = {
    vault = {
      name    = "chechia-vault"
      # FIXME fetch image sha256 with image tag
      image   = "sha256:0f260af414219f674a2b37bcc73fb1fe48051aac759a81d4d1ab488c34499ddb" # "hashicorp/vault:1.8.0"
      #command = ["server", "-dev"] # running in dev mode, already initialized but not able to restart
      command = ["server"]
      env = [
        "VAULT_LOCAL_CONFIG={\"backend\": {\"file\": {\"path\": \"/vault/file\"}}, \"default_lease_ttl\": \"168h\", \"max_lease_ttl\": \"720h\"}",
      ]
      privileged = true
      restart    = "no"

      ports = {
        vault-http = {
          internal = 8200
          external = 80
        }
      }
    }
  }

}
