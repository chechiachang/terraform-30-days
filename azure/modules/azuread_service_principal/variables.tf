# https://github.com/kumarvna/terraform-azuread-service-principal/blob/master/variables.tf
variable "service_principal_name" {
  description = "The name of the service principal"
  default     = ""
}

variable "role_definition_name" {
  description = "The name of a Azure built-in Role for the service principal"
  default     = null
}

variable "password_end_date" {
  description = "The relative duration or RFC3339 rotation timestamp after which the password expire"
  default     = null
}

variable "password_rotation_in_years" {
  description = "Number of years to add to the base timestamp to configure the password rotation timestamp. Conflicts with password_end_date and either one is specified and not the both"
  default     = null
}

variable "role_definition_names" {
  description = "The list of roles to this service principal"
  type        = set(string)
  default     = []
}

variable "enable_service_principal_certificate" {
  description = "Manages a Certificate associated with a Service Principal within Azure Active Directory"
  default     = true
}

variable "certificate_type" {
  description = "The type of key/certificate. Must be one of AsymmetricX509Cert or Symmetric"
  default     = "AsymmetricX509Cert"
}

variable "certificate_path" {
  description = "The path to the certificate for this Service Principal"
  default     = ""
}
