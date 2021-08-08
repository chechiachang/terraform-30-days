resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "main" {
  count = var.log_enabled ? 1 : 0
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.kubernetes_cluster_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "main" {
  count                 = var.log_enabled ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.main[0].location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main[0].id
  workspace_name        = azurerm_log_analytics_workspace.main[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.kubernetes_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.kubernetes_cluster_name

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard" # Private cluster
  }

  identity {
    type = "SystemAssigned"
  }

  private_cluster_enabled = false

  role_based_access_control {
    enabled = false
  }

  #service_principal {}

  tags = {
    environment = var.environment
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    dynamic "oms_agent" {
      for_each = var.log_enabled ? tolist(["1"]) : tolist([])
      content {
        enabled                    = var.log_enabled
        log_analytics_workspace_id = var.log_enabled ? azurerm_log_analytics_workspace.main[0].id : null
      }
    }
  }

  auto_scaler_profile {}

  default_node_pool {
    name       = "default"
    node_count = var.default_node_pool_count
    vm_size    = var.default_node_pool_vm_size
    # availability_zones = []

    enable_auto_scaling = false
    #max_count = 0
    #max_count = 0
    #node_count = 0

    enable_node_public_ip = false

    node_labels = {
      purpose = "general"
    }
    node_taints = []

    tags = {
      environment = var.environment
    }
  }
}
