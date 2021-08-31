# TERRAGRUNT CONFIGURATION

terraform {
  #source = "git::ssh://git@github.com/chechiachang/terraform-30-days.git//azure/modules/compute_network?ref=v0.0.3"
  #source = pathexpand("~/my-workspace/terraform-30-days//azure/modules/compute_network")
  source = "../../..//azure/modules/compute_network"

  before_hook "before_hook" {
    commands     = ["apply", "plan"]
    execute      = ["tfsec", "."]
  }

  after_hook "format" {
    commands     = ["apply"]
    execute      = ["terraform", "fmt", "--recursive"]
  }
}

# use terragrunt function to include .hcl file
# in this case, will find azure/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

inputs = {
  address_space = "10.2.0.0/16"

  subnet_prefixes = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24",
  ]

  subnet_names = [
    "dev-1",
    "dev-2",
    "dev-3",
  ]

  tags = {
    environment = "foundation"
  }
}
