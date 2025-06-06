# Private endpoint application security group associations
locals {
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
  # Convert RDP properties map to Azure-expected string format
  rdp_properties_string = join(";", concat([
    "drivestoredirect:s:${var.virtual_desktop_host_pool_custom_rdp_properties.drivestoredirect}",
    "audiomode:i:${var.virtual_desktop_host_pool_custom_rdp_properties.audiomode}",
    "videoplaybackmode:i:${var.virtual_desktop_host_pool_custom_rdp_properties.videoplaybackmode}",
    "redirectclipboard:i:${var.virtual_desktop_host_pool_custom_rdp_properties.redirectclipboard}",
    "redirectprinters:i:${var.virtual_desktop_host_pool_custom_rdp_properties.redirectprinters}",
    "devicestoredirect:s:${var.virtual_desktop_host_pool_custom_rdp_properties.devicestoredirect}",
    "redirectcomports:i:${var.virtual_desktop_host_pool_custom_rdp_properties.redirectcomports}",
    "redirectsmartcards:i:${var.virtual_desktop_host_pool_custom_rdp_properties.redirectsmartcards}",
    "usbdevicestoredirect:s:${var.virtual_desktop_host_pool_custom_rdp_properties.usbdevicestoredirect}",
    "enablecredsspsupport:i:${var.virtual_desktop_host_pool_custom_rdp_properties.enablecredsspsupport}",
    "use multimon:i:${var.virtual_desktop_host_pool_custom_rdp_properties.use_multimon}"
    ], [
    for key, value in var.virtual_desktop_host_pool_custom_rdp_properties.custom_properties : "${key}:${value}"
  ]))
}
