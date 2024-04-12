variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}


variable "virtual_desktop_host_pool_custom_rdp_properties" {
  type        = string
  default     = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:0"
  description = "(Optional) A valid custom RDP properties string for the Virtual Desktop Host Pool, available properties can be [found in this article](https://docs.microsoft.com/windows-server/remote/remote-desktop-services/clients/rdp-files)."
}

variable "virtual_desktop_host_pool_load_balancer_type" {
  type        = string
  default     = "BreadthFirst"
  description = "(Required) `BreadthFirst` load balancing distributes new user sessions across all available session hosts in the host pool. Possible values are `BreadthFirst`, `DepthFirst` and `Persistent`. `DepthFirst` load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold. `Persistent` should be used if the host pool type is `Personal`"
}

variable "virtual_desktop_host_pool_maximum_sessions_allowed" {
  type        = number
  default     = 16
  description = "(Optional) A valid integer value from 0 to 999999 for the maximum number of users that have concurrent sessions on a session host. Should only be set if the `type` of your Virtual Desktop Host Pool is `Pooled`."
}

variable "virtual_desktop_host_pool_name" {
  type        = string
  default     = "vdpool-avd-01"
  description = "The name of the AVD Host Pool."
  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.virtual_desktop_host_pool_name))
    error_message = "The name must be between 3 and 24 characters long and can only contain lowercase letters, numbers and dashes."
  }
}

variable "virtual_desktop_host_pool_start_vm_on_connect" {
  type        = bool
  default     = true
  description = "(Optional) Enables or disables the Start VM on Connection Feature. Defaults to `false`."
}

variable "virtual_desktop_host_pool_type" {
  type        = string
  default     = "Pooled"
  description = "The type of the AVD Host Pool. Valid values are 'Pooled' or 'Personal'."
}

variable "virtual_desktop_host_pool_load_balancer_type" {
  type        = string
  description = "(Required) `BreadthFirst` load balancing distributes new user sessions across all available session hosts in the host pool. Possible values are `BreadthFirst`, `DepthFirst` and `Persistent`. `DepthFirst` load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold. `Persistent` should be used if the host pool type is `Personal`"
  default     = "BreadthFirst"
}

variable "virtual_desktop_host_pool_custom_rdp_properties" {
  type        = string
  default     = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;use multimon:i:0"
  description = "(Optional) A valid custom RDP properties string for the Virtual Desktop Host Pool, available properties can be [found in this article](https://docs.microsoft.com/windows-server/remote/remote-desktop-services/clients/rdp-files)."
}

variable "virtual_desktop_host_pool_maximum_sessions_allowed" {
  type        = number
  default     = 16
  description = "(Optional) A valid integer value from 0 to 999999 for the maximum number of users that have concurrent sessions on a session host. Should only be set if the `type` of your Virtual Desktop Host Pool is `Pooled`."
}

variable "virtual_desktop_host_pool_start_vm_on_connect" {
  type        = bool
  default     = true
  description = "(Optional) Enables or disables the Start VM on Connection Feature. Defaults to `false`."
}
