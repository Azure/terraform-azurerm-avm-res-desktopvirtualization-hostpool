# We pick a random region from this list.
locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  azure_regions = [
    "westeurope",
    "northeurope",
    "eastus",
    "eastus2",
    "westus",
    "westus2",
    "southcentralus",
    "northcentralus",
    "centralus",
    "eastasia",
    "southeastasia",
  ]
}