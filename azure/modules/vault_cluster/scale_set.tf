module "scale_set" {
  source = "../linux_virtual_machine_scale_set"

  resource_group_name = var.resource_group_name
  environment         = var.environment
  location            = var.location

  name                    = var.name
  sku                     = var.sku
  instances               = var.instances
  network                 = var.network
  subnet                  = var.subnet
  priority                = var.priority
  max_bid_price           = var.max_bid_price
  source_image_publisher  = var.source_image_publisher
  source_image_offer      = var.source_image_offer
  source_image_sku        = var.source_image_sku
  ssh_key_file_path       = var.ssh_key_file_path
  allowed_ssh_cidr_blocks = var.allowed_ssh_cidr_blocks
  cloudconfig_file        = var.cloudconfig_file
}
