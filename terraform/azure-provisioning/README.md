# Terraform Azure Provisioning Subscription

When you first create a new Azure Tenant, Microsoft won't allow you to create resources without some form of Subscript that's tied to a Billing Account.

Part of provisioning my own Azure Infrastructure entails creating a subscription for Infrastructure-related assets, which would technically include the Terraform State Files being stored in Azure...However, I can't create the Azure Storage Account/Container/Blobs for Terraform State under my Infrastructure subscription, because it won't exist yet!

This set of Terraform files is used to locally/manually to provision a stand-alone `terraform-state` Subscription, under the Tenant's Root Management Group. Once run, the Terraform files in terraform-azure-state-mangagement can then be run successfully.

Note: You must be already logged in and authenticated using the Azure CLI ([more details](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)).


```

resource "azurerm_management_group_policy_assignment" "tenant_root_group" {
  name                 = "tenant_root_group-policy"
  policy_definition_id = azurerm_policy_set_definition.tenant_root_group.id
  management_group_id = data.azurerm_management_group.tenant_root.id
}

resource "azurerm_policy_set_definition" "tenant_root_group" {
  name         = "Tenant Root Group"
  policy_type  = "Custom"
  display_name = "Tenant Root Group"

  parameters = <<PARAMETERS
    {
        "allowedLocations": {
            "type": "Array",
            "metadata": {
                "description": "The list of allowed locations for resources.",
                "displayName": "Allowed locations",
                "strongType": "location"
            }
        }
    }
PARAMETERS

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }
}

```


## References

* [What are the Azure Management areas?](https://docs.microsoft.com/en-us/azure/governance/azure-management)
* [What are Azure management groups?](https://docs.microsoft.com/en-us/azure/governance/management-groups/overview)
* [Azure setup guide overview](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-setup-guide/)
* [azurerm_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group)
* [Data Source: azurerm_management_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group)
* [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
* [Define your tagging strategy](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)
