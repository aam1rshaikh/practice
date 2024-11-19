locals {
  orchestrated_vmss = {
    for k, v in try(var.deployment.orchestrated_vmss, {}) : k => merge(
      {
        # overrideable defaults
        location            = local.default_resource_group.location
        resource_group_name = local.default_resource_group.name
        lookup_id           = null
        zones               = ["1"]
      },
      v,
      {
        # fixed values and internal references
      }
    )
  }
}


# Create Orchestrated Virtual Machine Scale Sets if required
resource "azurerm_orchestrated_virtual_machine_scale_set" "orchestrated_vmss" {
  for_each = {
    for k, v in local.orchestrated_vmss : k => v if v.lookup_id == null
  }

  name                         = each.key
  location                     = each.value.location
  resource_group_name          = each.value.resource_group_name
  platform_fault_domain_count  = each.value.platform_fault_domain_count
  zones                        = each.value.zones
  single_placement_group       = false
}
