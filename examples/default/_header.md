# Default example

This deploys the module in its simplest form.

For custom rdp properties simple configuraton using defaults

```hcl
virtual_desktop_host_pool_custom_rdp_properties = {}
```

Override specific settings:

```hcl
virtual_desktop_host_pool_custom_rdp_properties = {
  audiomode        = 1 # Local audio only
  use_multimon     = 1 # Enable multi-monitor
  redirectprinters = 0 # Disable printer redirection
}
```

Add custom properties:

```hcl
virtual_desktop_host_pool_custom_rdp_properties = {
  audiomode = 1
  custom_properties = {
    "camerastoredirect" = "s:*"
    "redirectlocation"  = "i:1"
  }
}
```
