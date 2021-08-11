locals {
  location            = "southeastasia"
  environment         = "dev"
  resource_group_name = "terraform-30-days-poc"
}

# https://github.com/Azure/terraform-azurerm-compute
module "linuxservers" {
  source = "Azure/compute/azurerm"

  resource_group_name = local.resource_group_name

  vm_hostname  = "terraform-30-days"
  vm_size      = "Standard_B1s" # azure free plan
  vm_os_simple = "UbuntuServer"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  vnet_subnet_id = module.network.vnet_subnets[0]

  tags = {
    environment = local.environment
  }
}

# https://github.com/Azure/terraform-azurerm-network
module "network" {
  source = "Azure/network/azurerm"

  resource_group_name = local.resource_group_name

  address_space   = "10.2.0.0/16"
  subnet_prefixes = ["10.2.1.0/24"]
  subnet_names    = ["subnet-test-compute"]

  tags = {
    environment = local.environment
  }
}
