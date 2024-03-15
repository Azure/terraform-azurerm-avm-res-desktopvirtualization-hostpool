terraform {
  required_version = ">= 1.6.6, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.11.1, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

# This picks a random region from the list of regions.
resource "random_integer" "region_index" {
  min = 0
  max = length(local.azure_regions) - 1
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  name     = module.naming.resource_group.name_unique
  location = local.azure_regions[random_integer.region_index.result]
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

# This is the module call
module "hostpool" {
  source                                             = "../../"
  enable_telemetry                                   = var.enable_telemetry
  virtual_desktop_host_pool_location                 = azurerm_resource_group.this.location
  virtual_desktop_host_pool_name                     = var.virtual_desktop_host_pool_name
  virtual_desktop_host_pool_type                     = var.virtual_desktop_host_pool_type
  virtual_desktop_host_pool_resource_group_name      = azurerm_resource_group.this.name
  virtual_desktop_host_pool_load_balancer_type       = var.virtual_desktop_host_pool_load_balancer_type
  virtual_desktop_host_pool_custom_rdp_properties    = var.virtual_desktop_host_pool_custom_rdp_properties
  virtual_desktop_host_pool_maximum_sessions_allowed = var.virtual_desktop_host_pool_maximum_sessions_allowed
  virtual_desktop_host_pool_start_vm_on_connect      = var.virtual_desktop_host_pool_start_vm_on_connect
  resource_group_name                                = azurerm_resource_group.this.name
  diagnostic_settings = {
    to_law = {
      name                  = "to-law"
      workspace_resource_id = azurerm_log_analytics_workspace.this.id
      resource_group_name   = azurerm_resource_group.this.name
    }
  }
  virtual_desktop_host_pool_scheduled_agent_updates = {
    enabled = "true"
    schedule = tolist([{
      day_of_week = "Sunday"
      hour_of_day = 0
    }])
    use_session_host_timezone = "true"
  }
}
