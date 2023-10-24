# Create Azure Virtual Desktop host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  location                 = var.location            # The location where the host pool will be created.
  resource_group_name      = var.resource_group_name # The name of the resource group in which to create the host pool.
  name                     = var.hostpool
  friendly_name            = var.hostpool
  validate_environment     = false # [true false] 
  custom_rdp_properties    = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:0"
  description              = "HostPool"
  type                     = var.hostpooltype # ["Pooled" "Personal"]
  maximum_sessions_allowed = var.maxsessions
  load_balancer_type       = "BreadthFirst" #["BreadthFirst" "DepthFirst"]
  start_vm_on_connect      = "true"         # [true false]
  tags                     = var.tags
  scheduled_agent_updates {
    enabled                   = "true"
    timezone                  = "UTC"
    use_session_host_timezone = "false" # [true false]
    schedule {
      day_of_week = var.day_of_week # ["Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday"]
      hour_of_day = var.hour_of_day # [0-23]
    }
  }
}

# Registration information for the host pool.
resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = timeadd(timestamp(), "48h")
}

# Create Diagnostic Settings for AVD Host Pool
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each                       = var.diagnostic_settings
  name                           = each.value.name != null ? each.value.name : "diag-${var.hostpool}"
  target_resource_id             = azurerm_virtual_desktop_host_pool.hostpool.id
  storage_account_id             = each.value.storage_account_resource_id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  partner_solution_id            = each.value.marketplace_partner_resource_id
  log_analytics_workspace_id     = each.value.workspace_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = each.value.log_groups
    content {
      category_group = enabled_log.value
    }
  }
}

resource "azurerm_role_assignment" "this" {
  for_each                               = var.role_assignments
  scope                                  = azurerm_virtual_desktop_host_pool.hostpool.id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  principal_id                           = each.value.principal_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
}

resource "azurerm_management_lock" "this" {
  count      = var.lock.kind != "None" ? 1 : 0
  name       = coalesce(var.lock.name, "lock-${var.hostpool}")
  scope      = azurerm_virtual_desktop_host_pool.hostpool.id
  lock_level = var.lock.kind
}