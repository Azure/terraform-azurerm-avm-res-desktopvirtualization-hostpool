# Variables for the example module
variable "avd_vm_name" {
  type        = string
  default     = "vm-avd"
  description = "Base name for the Azure Virtual Desktop VMs"
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = { "Owner.Email" : "name@microsoft.com" }
  description = "A map of tags to add to all resources"
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
  default     = "vdpool-adds-01"
  description = "The name of the AVD Host Pool."
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

variable "vm_count" {
  type        = number
  default     = 1
  description = "Number of virtual machines to create"
}
