resource "random_id" "storage_account_name" {
  byte_length = 8
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "terraform" {
  name          = "terraform-backend-${random_id.storage_account_name.hex}"
  location      = "US"
  force_destroy = true

  storage_class = "STANDARD"

  uniform_bucket_level_access = false

  versioning {
    enabled = true
  }
}
