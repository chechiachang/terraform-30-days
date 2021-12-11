# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../..//localhost/modules/docker"
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
      image   = "sha256:0f2db50aecaf110c62d4659cb1ecbfb5416bbb3e7aa3fc709bd6de1fda74be2b" # "hashicorp/vault:1.9.1"
      command = ["server", "-dev"] # running in dev mode, already initialized but not able to restart
      #command = ["server"] # running in complete vault cluster. require complete configuration
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

      # FIXME lifecycle to recognize existing running docker container
    }
  }

}
