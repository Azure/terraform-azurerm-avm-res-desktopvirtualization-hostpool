# Create Azure Virtual Desktop host pool
resource "azurerm_virtual_desktop_host_pool" "this" {
  load_balancer_type               = var.virtual_desktop_host_pool_load_balancer_type
  location                         = var.virtual_desktop_host_pool_location
  name                             = var.virtual_desktop_host_pool_name
  resource_group_name              = var.virtual_desktop_host_pool_resource_group_name
  type                             = var.virtual_desktop_host_pool_type
  custom_rdp_properties            = var.virtual_desktop_host_pool_custom_rdp_properties
  description                      = var.virtual_desktop_host_pool_description
  friendly_name                    = var.virtual_desktop_host_pool_friendly_name
  maximum_sessions_allowed         = var.virtual_desktop_host_pool_maximum_sessions_allowed
  personal_desktop_assignment_type = var.virtual_desktop_host_pool_personal_desktop_assignment_type
  preferred_app_group_type         = var.virtual_desktop_host_pool_preferred_app_group_type
  start_vm_on_connect              = var.virtual_desktop_host_pool_start_vm_on_connect
  tags                             = var.virtual_desktop_host_pool_tags
  validate_environment             = var.virtual_desktop_host_pool_validate_environment

  dynamic "scheduled_agent_updates" {
    for_each = var.virtual_desktop_host_pool_scheduled_agent_updates == null ? [] : [var.virtual_desktop_host_pool_scheduled_agent_updates]
    content {
      enabled                   = scheduled_agent_updates.value.enabled
      timezone                  = scheduled_agent_updates.value.timezone
      use_session_host_timezone = scheduled_agent_updates.value.use_session_host_timezone

      dynamic "schedule" {
        for_each = scheduled_agent_updates.value.schedule == null ? [] : scheduled_agent_updates.value.schedule
        content {
          day_of_week = schedule.value.day_of_week
          hour_of_day = schedule.value.hour_of_day
        }
      }
    }
  }
  dynamic "timeouts" {
    for_each = var.virtual_desktop_host_pool_timeouts == null ? [] : [var.virtual_desktop_host_pool_timeouts]
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

# Registration information for the host pool.
resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  expiration_date = timeadd(timestamp(), "48h")
  hostpool_id     = azurerm_virtual_desktop_host_pool.this.id
}

# Create Diagnostic Settings for AVD Host Pool
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.virtual_desktop_host_pool_name}"
  target_resource_id             = azurerm_virtual_desktop_host_pool.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

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
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_virtual_desktop_host_pool.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_management_lock" "this" {
  count = var.lock.kind != "None" ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.virtual_desktop_host_pool_name}")
  scope      = azurerm_virtual_desktop_host_pool.this.id
}
