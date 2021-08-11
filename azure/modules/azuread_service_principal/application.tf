resource "azuread_application" "main" {
  display_name = var.service_principal_name
  #identifier_uris            = ["http://${var.service_principal_name}"]
  owners                     = [data.azuread_client_config.current.object_id]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}
