# TERRAGRUNT CONFIGURATION

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "docker" {
  host = "unix:///var/run/docker.sock"

  registry_auth {
    address     = "registry-1.docker.io"
    config_file = pathexpand("~/.docker/config.json")
  }
}
EOF
}

# localhost has no remote backend
