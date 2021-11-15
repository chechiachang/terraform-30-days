# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../..//gcp/foundation/compute_network"
}

include {
  path = find_in_parent_folders()
}
