module "docker" {
  source = "../../..//localhost/modules/docker"

  # Manage local docker images
  images = [
    "alpine:3.13",
    "quay.io/chechiachang/kubelet:v1.19.8",
    "gcr.io/google-containers/ubuntu:14.04"
  ]
}
