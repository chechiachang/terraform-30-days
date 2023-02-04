# TERRAGRUNT CONFIGURATION

# state to use existing resources in terraform_backend
remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket      = "terraform-backend-5600d411a367284b"
    prefix      = path_relative_to_include() # gcs::/path/default.tfstate
    //credentials = "/Users/che-chia/.config/gcloud/terraform-service-account.json"
  }
}

terraform {
  //extra_arguments "env" {
  //  commands = get_terraform_commands_that_need_vars()
  //  required_var_files = [
  //    "${get_parent_terragrunt_dir()}/env.tfvars",
  //  ]
  //}
}
