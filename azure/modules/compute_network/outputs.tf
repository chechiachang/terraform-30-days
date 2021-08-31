output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "The name of the newly created vNet"
  value       = module.network.vnet_name
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = module.network.vnet_location
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = module.network.vnet_address_space
}

output "vnet_subnets" {
  description = "The ids of subnets created inside the newly created vNet"
  value       = module.network.vnet_subnets
}
