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
  default     = "hostpool-1"
  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.hostpool))
    error_message = "The name must be between 3 and 24 characters long and can only contain lowercase letters, numbers and dashes."
  }
}

variable "hostpooltype" {
  type        = string
  default     = "Pooled"
  description = "The type of the AVD Host Pool. Valid values are 'Pooled' or 'Personal'."
}
