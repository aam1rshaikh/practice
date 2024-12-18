#
# Log Analytics
#
# This file contains all the resource defintions required
# to build the log analytics capability
#
# Logic Overview:
# * Generate a list of log analytics workspaces to create
# * Create them
# * Look them up to use as references by other resources
# * Generate a list of solutions to apply to each workspace
# * Create them


# create a list of log analytics workspaces to create by combining
# defaults, inputs, fixed values and internal references  
locals {
  log_analytics_workspaces = {
    for k, v in try(var.foundation.log_analytics_workspaces, {}) : k => merge(
      {
        # overrideable defaults
        retention_in_days   = 30
        solutions           = []
        location            = local.default_resource_group.location
        resource_group_name = local.default_resource_group.name
        sku                 = "PerGB2018"
      },
      v,
      {
        # fixed values and internal references

      }
    )
  }
}

# create log analytics components
resource "azurerm_log_analytics_workspace" "log_analytics" {
  for_each = local.log_analytics_workspaces

  name                = each.key
  location            = each.value.location
  resource_group_name = local.all_resource_groups[each.value.resource_group_name].name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days

}

# create data references for the created components
data "azurerm_log_analytics_workspace" "log_analytics" {
  for_each = local.log_analytics_workspaces

  name                = each.key
  resource_group_name = each.value.resource_group_name

  # should resource block above be a lookup?!
  depends_on = [azurerm_log_analytics_workspace.log_analytics]
}

# create a list of solutions to create across all defined workspaces
locals {
  log_analytics_solutions = {
    for entry in flatten([
      for law_k, law_v in local.log_analytics_workspaces : [
        for solution in law_v.solutions :
        merge(
          {
            workspace_resource_id = azurerm_log_analytics_workspace.log_analytics[law_k].id
            workspace_name        = azurerm_log_analytics_workspace.log_analytics[law_k].name
          },
          law_v,
          solution
        )
      ]
    ]) : "${entry.workspace_name}-${entry.solution_name}" => entry
  }
}

#Install Service Map Solution
resource "azurerm_log_analytics_solution" "log_analytics" {
  for_each = local.log_analytics_solutions

  solution_name         = each.value.solution_name
  location              = each.value.location
  resource_group_name   = local.all_resource_groups[each.value.resource_group_name].name
  workspace_resource_id = each.value.workspace_resource_id
  workspace_name        = each.value.workspace_name
  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }
}
/*
*/