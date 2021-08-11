resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "time_rotating" "main" {
  rotation_rfc3339 = var.password_end_date
  rotation_years   = var.password_rotation_in_years

  triggers = {
    end_date = var.password_end_date
    years    = var.password_rotation_in_years
  }
}

resource "random_password" "passwd" {
  count       = !var.enable_service_principal_certificate ? 1 : 0
  length      = 32
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4

  keepers = {
    service_principal_password = time_rotating.main.id
  }
}

resource "azuread_service_principal_password" "main" {
  count                = !var.enable_service_principal_certificate ? 1 : 0
  service_principal_id = azuread_service_principal.main.id
  value                = random_password.passwd[0].result
  end_date             = time_rotating.main.rotation_rfc3339
}

resource "azurerm_role_assignment" "main" {
  for_each = var.role_definition_names

  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = each.value
  principal_id         = azuread_service_principal.main.object_id
}

resource "azuread_service_principal_certificate" "main" {
  count                = var.enable_service_principal_certificate ? 1 : 0
  service_principal_id = azuread_service_principal.main.id
  type                 = var.certificate_type
  value                = file(var.certificate_path)
  end_date             = time_rotating.main.rotation_rfc3339
}

