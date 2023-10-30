# We pick a random region from this list.
locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  azure_regions = [
    "centralindia",
    "uksouth",
    "ukwest",
    "japaneast",
    "australiaeast",
    "canadaeast",
    "canadacentral",
    "northeurope",
    "westeurope",
    "eastus",
    "eastus2",
    "westus",
    "westus2",
    "westus3",
    "northcentralus",
    "southcentralus",
    "westcentralus",
    "centralus",
  ]
}
