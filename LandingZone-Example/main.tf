/* ==============================================
   ==            Landing Zone Main             ==
   == Example Terraform Code for Landing Zone  ==
   ==============================================

              Author: Ruan Mentz
               Date: 2025-07-08  
*/

# Standard provider block using pref. config.
# Targeting "default" subscription and used for "Core Resource/s" deployment.
terraform {
    backend "azurerm" {
        resource_group_name  = "rg-tfstate-SMGT-PRD-01"
        storage_account_name = "st-tfstate-SMGT-PRD-01"
        container_name       = "statefiles"
        key                  = "landingzone.tfstate"
        subscription_id      = "THE SUBSCRIPTION ID"
        use_azuread_auth     = true
    }
}

# Deployment zone for "Connectivity Resource/s"
provider "azurerm" {
    alias                   = "connectivity"
    subscription_id         = "THE SUBSCRIPTION ID"
    features {}  
}

# Deployment zone for "Management Resource/s"
provider "azurerm" {
    alias                   = "management"
    subscription_id         = "THE SUBSCRIPTION ID"
    features {}  
}

data "azurerm_client_config" "current" {}

data "azurerm_client_config" "connectivity" {
    provider = azurerm.connectivity
}

data "azurerm_client_config" "management" {
    provider = azurerm.management
}

module "FOUNDATION" {
    # source can also be from git repo. eg. source = "git::https://...yoursource.git/"
    source = "../foundation/"

    # File where extensions are copied to.
    custom_library_path = "../foundation/lib/"

    # File where extensions are copied from.
    custom_library_extension_path = "./lib"

    # Section for Policy Overrides
    securePolicy_parameterOverrides = {
        "policy-cis1-511" = { effect = "Audit"},
        "policy-cis2-77"  = { effect = "Audit"},
        "policy-cis2-516" = { effect = "AuditIfNotExists" }
    }

    # Client Custom Landing Zone - MDC, Prd, Non-Prd, Sec-Prd, Sec-Non-Prd, Foundation
    custom_landing_zone = {
        "mdc" = {
            display_name                = "YOUR-MDC-NAME"
            parent_management_group_id  = data.azurerm_client_config.current.tenant_id
            subscription_ids            = []
            archetype_config = {
                "archetype_id"   = "custom_root"
                "parameters"     = {}
                "access_control" = {}
            }
        }

        # Production custom landing zone
        "production" = {
            display_name               = "Production"
            parent_management_group_id = "mdc"
            subscription_ids           = [
                "SUBSCRIPTION ID 1", # SUBSCRIPTION ID1 NAME
                "SUBSCRIPTION ID 2"  # SUBSCRIPTION ID2 NAME
            ]
            archetype_config = {
                "archetype_id"   = "high_secure"
                "parameters"     = {}
                "access_control" = {}
            }
        }

        # Non-Production custom landing zone
        "non-production" = {
            display_name               = "Non-Production"
            parent_management_group_id = "mdc"
            subscription_ids           = [
                "SUBSCRIPTION ID 1", # SUBSCRIPTION ID1 NAME
                "SUBSCRIPTION ID 2"  # SUBSCRIPTION ID2 NAME
            ]
            archetype_config = {
                "archetype_id"   = "high_secure"
                "parameters"     = {}
                "access_control" = {}
            }
        }

        # Security Production custom landing zone
        "security-production" = {
            display_name               = "Security Production"
            parent_management_group_id = "mdc"
            subscription_ids           = [
                "SUBSCRIPTION ID 1" # SUBSCRIPTION ID1 NAME
            ]
            archetype_config = {
                "archetype_id"   = "high_secure"
                "parameters"     = {}
                "access_control" = {}
            }
        }

        # Security Non-Production custom landing zone
        "security-non-production" = {
            display_name               = "Security Non-Production"
            parent_management_group_id = "mdc"
            subscription_ids           = [
                "SUBSCRIPTION ID 1" # SUBSCRIPTION ID1 NAME
            ]
            archetype_config = {
                "archetype_id"   = "high_secure"
                "parameters"     = {}
                "access_control" = {}
            }
        }

        # Foundation custom landing zone (FOR OLDER CLIENTS)
        # "foundation" = {
        #     display_name               = "Foundation"
        #     parent_management_group_id = "mdc"
        #     subscription_ids           = [
        #         "SUBSCRIPTION ID 1", # SUBSCRIPTION ID1 NAME
        #         "SUBSCRIPTION ID 2"  # SUBSCRIPTION ID2 NAME
        #     ]
        #     archetype_config = {
        #         "archetype_id"   = "high_secure_not_enforced"
        #         "parameters"     = {}
        #         "access_control" = {}
        #     }
        # }
    }

    # Required Providers (DO NOT CHANGE)
    providers = {
        azurerm              = azurerm
        azurerm.connectivity = azurerm.connectivity
        azurerm.management   = azurerm.management
    }

    # Cloudspaces starting definition
    cloudspaces_id = local.cloudspaces_id
    cloudspaces_name = local.cloudspaces_name

    # Compliancy Workbook definition
    workbook_name = "YOUR-WORKBOOK-DEPLOY-NAME" # Deployment Name, not the workbook name
    workbook_resource_group = "rg-tfstate-SMGT-PRD-01"

    # Default Policy Mode
    cloudspaces_cis2_policy_mode = "Default"
    
    # Security Contact addressing
    security_alerts_email = local.security_alerts_email
    emailSecurityContact  = local.emailSecurityContact

    security_center_enabled               = true
    cloudspaces_standard_subscriptions    = local.cloudspaces_standard_subscriptions
    cloudspaces_high_secure_subscriptions = local.cloudspaces_high_secure_subscriptions

    # Management Resources
    deploy_management_resources    = local.deploy_management_resources
    subscription_id_management     = data.azurerm_client_config.management.subscription_id # MGT-PRD
    configure_management_resources = var.configure_management_resources

    # Connectivity Resources
    deploy_connectivity_resources    = local.deploy_connectivity_resources
    subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id # CON-PRD
    configure_connectivity_resources = var.configure_connectivity_resources
}

resource "azurerm_consumption_budget_subscription" "budget" {
    for_each = local.budget_for_subscriptions # settings.generic file item

    subscription_id = each.key
    name            = "budget-for-${each.value.name}"
    amount          = each.value.amount
    time_grain      = each.value.time_grain

    time_period {
        start_date = each.value.start_date
        end_date   = each.value.end_date
    }
    notification {
        enabled        = each.value.notification.enabled
        threshold      = each.value.notification.threshold
        operator       = each.value.notification.operator
        contact_emails = each.value.notification.contact_emails
    }
}

# Enabling Microsoft Defender for Cloud for all subscriptions
# Done per subscription for now in this Terraform module.
# (Maybe set policy that checks this in the future to be in remediation mode)
# Example given below:

# resource "azurerm_security_center_subscription_pricing" "dfcconprd" {
#     tier          = "Standard"
#     for_each      = local.defender_for_cloud_plans # settings.generic file item
#     resource_type = each.key
#     subplan       = each.value.subplan

#     dynamic "extension" {
#         for_each = each.value.extensions
#         content {
#             name = extension.value.name
#             additional_extension_properties = extension.value.additional_extension_properties
#         }
#     }
#     provider = azurerm.con-prd # YOUR CON PRD SUBSCRIPTION
# }

# resource "azurerm_security_center_auto_provisioning" "auto-provisioning-con-prd" {
#     auto_provision = "On" 
#     provider       = azurerm.con-prd
# }