provider "google" {
  project = "terraform-30-days"
  region  = "us-west1"
  # Use us-west1 for free tier
  # https://cloud.google.com/free/docs/gcp-free-tier/#storage
  # - 5G/month for data in us-west1
  # - 1G networking for data from us-west1
}
