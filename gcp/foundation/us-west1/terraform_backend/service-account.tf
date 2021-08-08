# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
#resource "google_service_account" "service_account" {
#  account_id   = "terraform"
#  display_name = "Service Account"
#}

# https://github.com/terraform-google-modules/terraform-google-service-accounts
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  project_id    = "terraform-30-days"
  version       = "~> 3.0"
  prefix        = "terraform"
  names         = ["terraform"]
  generate_keys = true # NOTE: save priavte key in terraform state
  project_roles = [
    "terraform-30-days=>roles/editor",
    "terraform-30-days=>roles/storage.objectViewer",
  ]
}

# This will write private key json to local
resource "local_file" "service_account" {
  # WARNING: it's usually a bad thing to use nonsensitive(). We'll allow this time
  # - should avoid gererate key in terraform state at first place
  content  = nonsensitive(module.service_accounts.keys["terraform"])
  filename = pathexpand("~/.config/gcloud/terraform-service-account.json")
}
