terraform {
  //source = "terraform-google-modules/network/google"
  source  = "git::https://github.com/terraform-google-modules/terraform-google-network.git//?ref=v6.0.1"
}

include {
  path = find_in_parent_folders()
}

locals {
  project = yamldecode(file(find_in_parent_folders("project_vars.yaml")))
  env     = yamldecode(file(find_in_parent_folders("env_vars.yaml")))
}

inputs = {
  project_id   = local.project.name
  network_name = "${local.project.prefix}-${local.env.prefix}-vpc"
  routing_mode = "REGIONAL"

  subnets = [
    // us-west1
    {
      subnet_name   = "${local.project.prefix}-${local.env.prefix}-subnet-int"
      subnet_ip     = "10.10.0.0/20"
      subnet_region = "us-west1"

      description = "Subnet for ${local.env.prefix} product internal services"
      //subnet_private_access = "true"
      //subnet_flow_logs          = "true"
      //subnet_flow_logs_interval = "INTERVAL_10_MIN"
      //subnet_flow_logs_sampling = 0.7
      //subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name   = "${local.project.prefix}-${local.env.prefix}-subnet-ext"
      subnet_ip     = "10.10.32.0/20"
      subnet_region = "us-west1"

      description = "Subnet for ${local.env.prefix} product external services"
      //subnet_private_access = "true"
      //subnet_flow_logs          = "true"
      //subnet_flow_logs_interval = "INTERVAL_10_MIN"
      //subnet_flow_logs_sampling = 0.7
      //subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    },
    {
      subnet_name   = "${local.project.prefix}-${local.env.prefix}-subnet-dmz"
      subnet_ip     = "10.10.64.0/20"
      subnet_region = "us-west1"

      description = "Subnet for ${local.env.prefix} gcp user-facing services"
      //subnet_private_access = "true"
      //subnet_flow_logs          = "true"
      //subnet_flow_logs_interval = "INTERVAL_10_MIN"
      //subnet_flow_logs_sampling = 0.7
      //subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]

  secondary_ranges = {
    tf30-dev-subnet-int = [
      //{
      //    range_name    = "subnet-01-secondary-01"
      //    ip_cidr_range = "192.168.64.0/24"
      //},
    ]
    tf30-dev-subnet-ext = []
    tf30-dev-subnet-dmz = []
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
    //{
    //    name                   = "app-proxy"
    //    description            = "route through proxy to reach app"
    //    destination_range      = "10.50.10.0/24"
    //    tags                   = "app-proxy"
    //    next_hop_instance      = "app-proxy-instance"
    //    next_hop_instance_zone = "us-west1-a"
    //},
  ]
}
