# https://github.com/terraform-google-modules/terraform-google-network
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = "terraform-30-days"
  network_name = "vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "dev-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-west1"
    },
    {
      subnet_name   = "dev-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = "us-west1"
      #subnet_private_access = "true"
      #subnet_flow_logs      = "true"
      #description           = "This subnet has a description"
    },
    {
      subnet_name   = "dev-03"
      subnet_ip     = "10.10.30.0/24"
      subnet_region = "us-west1"
      #subnet_flow_logs          = "true"
      #subnet_flow_logs_interval = "INTERVAL_10_MIN"
      #subnet_flow_logs_sampling = 0.7
      #subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]

  #secondary_ranges = {
  #    dev-01 = [
  #        {
  #            range_name    = "subnet-01-secondary-01"
  #            ip_cidr_range = "192.168.64.0/24"
  #        },
  #    ]

  #    dev-02 = []
  #}

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
    #{
    #    name                   = "app-proxy"
    #    description            = "route through proxy to reach app"
    #    destination_range      = "10.50.10.0/24"
    #    tags                   = "app-proxy"
    #    next_hop_instance      = "app-proxy-instance"
    #    next_hop_instance_zone = "us-west1-a"
    #},
  ]
}
