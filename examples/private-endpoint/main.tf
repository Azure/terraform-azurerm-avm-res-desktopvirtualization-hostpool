terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
}

provider "azurerm" {
  features {}
}


# This is required for resource modules
resource "azurerm_resource_group" "rghp" {
  name     = module.naming.resource_group.name_unique
  location = var.location
}

# A vnet is required for the private endpoint.
resource "azurerm_virtual_network" "this" {
  name                = module.naming.virtual_network.name_unique
  location            = azurerm_resource_group.rghp.location
  resource_group_name = azurerm_resource_group.rghp.name
  address_space       = ["192.168.0.0/24"]
}

resource "azurerm_subnet" "this" {
  name                 = module.naming.subnet.name_unique
  resource_group_name  = azurerm_resource_group.rghp.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.wvd.microsoft.com"
  resource_group_name = azurerm_resource_group.rghp.name
}

# This is the module call
module "hostpool" {
  source              = "../../"
  enable_telemetry    = var.enable_telemetry
  hostpool            = var.hostpool
  hostpooltype        = var.hostpooltype
  location            = azurerm_resource_group.rghp.location
  resource_group_name = azurerm_resource_group.rghp.name
  avdlawrgname        = var.avdlawrgname
  avdlaworkspace      = var.avdlaworkspace
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.this.id]
      subnet_resource_id            = azurerm_subnet.this.id
    }
  }
}
