variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "hostpool" {
  type        = string
  description = "The name of the AVD Host Pool."
  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.hostpool))
    error_message = "The name must be between 3 and 24 characters long and can only contain lowercase letters, numbers and dashes."
  }
}

variable "location" {
  type        = string
  description = "The Azure location where the resources will be deployed."
}

variable "hostpooltype" {
  type        = string
  description = "The type of the AVD Host Pool. Valid values are 'Pooled' and 'Personal'."
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to assign to the Key Vault resource."
  default     = null
}

# Diagnostic Settings variables
# Define the input variable for the log categories to be enabled for the host pool
variable "host_pool_log_categories" {
  type        = list(string)
  description = "Value of the log categories to be enabled for the host pool"
  default     = ["Checkpoint", "Management", "Connection", "HostRegistration", "AgentHealthStatus", "NetworkData", "SessionHostManagement", "ConnectionGraphicsData", "Error"]

}

# Define the input variable for the name of the AVD Log Analytics Workspace
# It is recommended to have a single Log Analytics Workspace for all AVD resources
variable "avdlaworkspace" {
  description = "Name of the AVD Log Analytics Workspace"
}

variable "avdlawrgname" {
  description = "Name of the AVD Log Analytics Workspace Resource Group"
}

variable "diagname" {
  type        = string
  description = "Name of the Diagnostic Setting"
  default     = "hplogs"
}

variable "lock" {
  type = object({
    name = optional(string, null)
    kind = optional(string, "ReadOnly")
  })
  description = "The lock level to apply to the AVD Host Pool. Default is `ReadOnly`. Possible values are`CanNotDelete`, and `ReadOnly`."
  default     = {}
  nullable    = false
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock.kind)
    error_message = "The lock level must be one of: 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    condition                              = string
    condition_version                      = string
    skip_service_principal_aad_check       = bool
    delegated_managed_identity_resource_id = string
  }))
  description = "Map of role assignments to assign to the host pool."
  default     = {}
}
  