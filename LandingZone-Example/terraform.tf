# Terraform configuration of version and features{} for each provider.

terraform {
    required_version = ">= 1.3.1"
    required_providers {
        azurerm = "~> 3"
        random  = ">= 3.1.0"
        time    = ">= 0.7.0"
    }
}
provider "azurerm" {
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}

# Provider lists for "producation" and "non-production" subscriptions. 
# Same as listed in the main.tf file
# Example given below

provider "azurerm" {
    alias           = "prd"
    subscription_id = "YOUR_PRD_SUBSCRIPTION_ID"
    features {}
}

#...