# https://github.com/Azure/terraform-azurerm-compute
module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = var.resource_group_name
  vm_hostname         = var.vm_hostname
  vm_size             = var.vm_size
  vm_os_simple        = var.vm_os_simple
  public_ip_dns       = var.public_ip_dns
  vnet_subnet_id      = var.vnet_subnet_id

  ssh_key                 = var.ssh_key
  remote_port             = var.remote_port
  source_address_prefixes = var.source_address_prefixes

  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  custom_data = data.template_cloudinit_config.config.rendered

  tags = {
    environment = var.environment
    managed_by  = "terraform" # tag resource managed by terraform. Shouldn't be changed manually on web portal.
  }
}
