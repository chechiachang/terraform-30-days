# TERRAGRUNT CONFIGURATION

# state to use existing resources in terraform_backend
remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # key = "azure/storage/container/southeastasia/terraform_backend/terraform.tfstate"
    key = "${path_relative_to_include()}/terraform.tfstate"
    # https://terragrunt.gruntwork.io/docs/reference/built-in-functions/#path_relative_to_include
    # ex. file to include is ./terragrunt.hcl
    #     cd southeastasia/terraform_backend
    #     path_relative_to_include() = southeastasia/terraform_backend
    #     and then put terraform.tfstate to azure/storage/container/southeastasia/terraform_backend
    #     check terraform.tfstate file on azure storage explorer
    resource_group_name  = "terraform-30-days"
    storage_account_name = "tfstatee903f2ef317fb0b4"
    container_name       = "tfstate"
  }
}

terraform {
  extra_arguments "env" {
    commands = get_terraform_commands_that_need_vars()
    required_var_files = [
      "${get_parent_terragrunt_dir()}/env.tfvars",
    ]
  }
}
