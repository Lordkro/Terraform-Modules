# Policy Exemptions to Security Policies
# Just a few examples that might affect your client systems.

locals {
    cis1exemptions = [
        "An activity log alert should exist for specific Policy operations",
        "An activity log alert should exist for specific Administrative operations",
        "An activity log alert should exist for specific Security operations"
    ]
    cis2exemptions = [
        "policy-vm-cis2-74", # Unattached disks for VMs must be encrypted using CMK
        "storage accounts should use customer-managed key for encryption",
        "os and data disks should be encrypted with a customer-managed key",
        "endpoint portection should be installed on your machines", # Policy reportedly broken as of 16/08/2024
        "Storage aacount containing container with activity logs must be encrypted with BYOK"
    ]
}

# Production Examples
data "azurerm_management_group" "production" {
    name = "production"
}

resource "azurerm_management_group_policy_exemption" "production-exemptions-cis1" {
    name                 = "production-exemptions-cis1"
    management_group_id  = data.azurerm_management_group.production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/assign-cis1"
    policy_definition_reference_ids = local.cis1exemptions
    exemption_category   = "Waiver"
}

resource "azurerm_management_group_policy_exemption" "production-exemptions-cis2" {
    name                 = "production-exemptions-cis2"
    management_group_id  = data.azurerm_management_group.production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/assign-cis2"
    policy_definition_reference_ids = local.cis2exemptions
    exemption_category   = "Waiver"
}

# Non-prodcution Examples
data "azurerm_management_group" "non-production" {
    name = "non-production"
}

resource "azurerm_management_group_policy_exemption" "non-production-exemptions-cis1" {
    name                 = "non-production-exemptions-cis1"
    management_group_id  = data.azurerm_management_group.non-production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/non-production/providers/microsoft.authorization/policyassignments/assign-cis1"
    policy_definition_reference_ids = local.cis1exemptions
    exemption_category   = "Waiver"
}

resource "azurerm_management_group_policy_exemption" "non-production-exemptions-cis2" {
    name                 = "non-production-exemptions-cis2"
    management_group_id  = data.azurerm_management_group.non-production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/non-production/providers/microsoft.authorization/policyassignments/assign-cis2"
    policy_definition_reference_ids = local.cis2exemptions
    exemption_category   = "Waiver"
}

# Security Production Examples
data "azurerm_management_group" "security-production" {
    name = "security-production"
}

resource "azurerm_management_group_policy_exemption" "security-production-exemptions-cis1" {
    name                 = "security-production-exemptions-cis1"
    management_group_id  = data.azurerm_management_group.security-production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/security-production/providers/microsoft.authorization/policyassignments/assign-cis1"
    policy_definition_reference_ids = local.cis1exemptions
    exemption_category   = "Waiver"
}

resource "azurerm_management_group_policy_exemption" "security-production-exemptions-cis2" {
    name                 = "security-production-exemptions-cis2"
    management_group_id  = data.azurerm_management_group.security-production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/security-production/providers/microsoft.authorization/policyassignments/assign-cis2"
    policy_definition_reference_ids = local.cis2exemptions
    exemption_category   = "Waiver"
}

# Security Non-Production Examples
data "azurerm_management_group" "security-non-production" {
    name = "security-non-production"
}

resource "azurerm_management_group_policy_exemption" "security-non-production-exemptions-cis1" {
    name                 = "security-non-production-exemptions-cis1"
    management_group_id  = data.azurerm_management_group.security-non-production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/security-non-production/providers/microsoft.authorization/policyassignments/assign-cis1"
    policy_definition_reference_ids = local.cis1exemptions
    exemption_category   = "Waiver"
}

resource "azurerm_management_group_policy_exemption" "security-non-production-exemptions-cis2" {
    name                 = "security-non-production-exemptions-cis2"
    management_group_id  = data.azurerm_management_group.security-non-production.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/security-non-production/providers/microsoft.authorization/policyassignments/assign-cis2"
    policy_definition_reference_ids = local.cis2exemptions
    exemption_category   = "Waiver"
}

#############################################
#       Individual resource exemptions      #
#############################################

data "azurerm_public_ip" "firewallip" {
    name = "pip-scon-prd-01"
    resource_group_name = "rg-scon-prd-01"
    provider = azurerm.con-prd # Subscription for connectivity production
}

resource "azurerm_resource_policy_exemption" "firewall-ip-exemption" {
    name                 = "firewall-ip-exemption"
    resource_id          = data.azurerm_public_ip.firewallip.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/assign-cis1"
    policy_definition_reference_ids = ["policy-pip-cis1-67"] # Ensure that Public IP addresses are Evaluated on a Periodic Basis
    exemption_category   = "Mitigated"
}

data "azurerm_public_ip" "vpnip" {
    name                = "pip-vgw-scon-prd-01"
    resource_group_name = "rg-vpn-scon-prd-01"
    provider      = azurerm.con-prd # Subscription for connectivity production
}

resource "azurerm_resource_policy_exemption" "vpn-ip-exemption" {
    name                 = "vpn-ip-exemption"
    resource_id          = data.azurerm_public_ip.vpnip.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/assign-cis1"
    policy_definition_reference_ids = ["policy-pip-cis1-67"] # Ensure that Public IP addresses are Evaluated on a Periodic Basis
    exemption_category   = "Mitigated"
}

data "azurerm_public_ip" "addsip" {
    name                = "aadds-3480###########################47ebd-pip" # Example name
    resource_group_name = "rg-adds-smgt-prd-01"
    provider      = azurerm.mgt-prd # Subscription for management production
}

resource "azurerm_resource_policy_exemption" "adds-ip-exemption" {
    name                 = "adds-ip-exemption"
    resource_id          = data.azurerm_public_ip.addsip.id
    policy_assignment_id = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/assign-cis1"
    policy_definition_reference_ids = ["policy-pip-cis1-67"] # Ensure that Public IP addresses are Evaluated on a Periodic Basis
    exemption_category   = "Mitigated"
}

#############################################
#           Remediation Examples            #
#############################################

resource "azurerm_subscription_policy_remediation" "remediation1" {
    name                    = "remediation1"
    subscription_id         = "/subscriptions/YOURSUBCRIPTION_ID"
    policy_assignment_id    = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/diagset-sentinel"
    resource_discovery_mode = "ReEvaluateCompliance"
}

resource "azurerm_subscription_policy_remediation" "remediation2" {
    name                    = "remediation2"
    subscription_id         = "/subscriptions/YOURSUBCRIPTION_ID"
    policy_assignment_id    = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/diagset-sentinel"
    resource_discovery_mode = "ReEvaluateCompliance"
}

resource "azurerm_subscription_policy_remediation" "remediation3" {
    name                    = "remediation3"
    subscription_id         = "/subscriptions/YOURSUBCRIPTION_ID"
    policy_assignment_id    = "/providers/microsoft.management/managementgroups/production/providers/microsoft.authorization/policyassignments/diagset-sentinel"
    resource_discovery_mode = "ReEvaluateCompliance"
}

#############################################
#   Massive Blocks of Items & Exemptions    #
#############################################

variable "VaultRBACExemptionIds" {
    default = [
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-nonprd01-0001/providers/microsoft.keyvault/vaults/kv-NONPRD-01",
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-nonprd01-0002/providers/microsoft.keyvault/vaults/kv-NONPRD-02",
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-nonprd01-0003/providers/microsoft.keyvault/vaults/kv-NONPRD-03", 
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-nonprd01-0004/providers/microsoft.keyvault/vaults/kv-NONPRD-04",
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-prd01-0001/providers/microsoft.keyvault/vaults/kv-PRD-01", 
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-prd01-0002/providers/microsoft.keyvault/vaults/kv-PRD-01",
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-prd01-0003/providers/microsoft.keyvault/vaults/kv-PRD-01",
        "/subscriptions/YOURSUBCRIPTION_ID/resourcegroups/rg-ew-prd01-0004/providers/microsoft.keyvault/vaults/kv-PRD-01"
    ]
}
resource "azurerm_resource_policy_exemption" "Vault-RBAC-Permission-Exemption" {
    for_each             = {for idx, exemption in var.VaultRBACExemptionIds: idx => exemption}
    name                 = "Vault-RBAC-Permission-Exemption${each.key + 1}"
    policy_assignment_id = "/providers/microsoft.management/managementgroups/foundation/providers/microsoft.authorization/policyassignments/assign-cis2-ne"
    policy_definition_reference_ids = ["azure key vault should use rbac permission model"] # Azure key vault should use rbac permission model
    exemption_category   = "Waiver"
    resource_id          = each.value
}
resource "azurerm_resource_policy_exemption" "Vault-RBAC-Enabled-Exemption" {
    for_each             = {for idx, exemption in var.VaultRBACExemptionIds: idx => exemption}
    name                 = "Vault-RBAC-Enabled-Exemption${each.key + 1}"
    policy_assignment_id = "/providers/microsoft.management/managementgroups/foundation/providers/microsoft.authorization/policyassignments/assign-cis2-ne"
    policy_definition_reference_ids = ["policy-kv-cis2-86"] # Enable Role Based Access Control for Azure Key Vault
    exemption_category   = "Waiver"
    resource_id          = each.value
}