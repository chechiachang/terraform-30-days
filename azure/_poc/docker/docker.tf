module "docker" {
  source = "../../..//utils/modules/docker"

  # Manage local docker containers
  containers = {
    ubuntu = {
      name  = "ubuntu"
      image = "gcr.io/google-containers/ubuntu:14.04"
      entrypoint = ["sleep", "36000"]
    }
  }

  # Manage local docker images
  images = [
    "alpine:3.13",
    "quay.io/chechiachang/kubelet:v1.19.8",
    "gcr.io/google-containers/ubuntu:14.04"
  ]
}
