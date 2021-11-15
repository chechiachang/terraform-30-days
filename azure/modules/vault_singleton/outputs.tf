output "public_ip_address" {
  value = module.linuxservers.public_ip_address
}

output "public_ip_dns_name" {
  value = module.linuxservers.public_ip_dns_name
}

output "network_interface_ids" {
  value = module.linuxservers.network_interface_ids
}
