# Local variables for the Landing Zone example
locals {
    cloudspaces_root_id = "TEST_ROOT_ID" # Replace with your actual root ID
    cloudspaces_root_name = "MDC"

    cloudspaces_standard_subscriptions = ["SUBSCRIPTION ID"]
    cloudspaces_high_secure_subscriptions = []

    location = "westeurope"
    resource_tags = {
        Owner = "Manager IT"
        Application = "Landing Zone"
        Environment = "PRD"
        Costcenter = "00000" # Replace with your actual cost center
        Availability = "24/7"
        Business_critical = "True"
    }

    defender_for_cloud_plans = {
        "Api" = {
            subplan = "P1"
            extensions = []
        }
        "AppService" = {
            subplan = ""
            extensions = []
        }
        "KeyVaults" = {
            subplan = "PerKeyVault"
            extensions = []
        }
        "SQLServers" = {
            subplan = ""
            extensions = []
        }
        "SqlServerVirtualMachines" = {
            subplan = ""
            extensions = []
        }
        "StorageAccounts" = {
            subplan = "PerTransaction"
            extensions = []
        }
        "VirtualMachines" = {
            subplan = "P2"
            extensions = [{
                name = "AgentlessVmScanning"
                additional_extension_properties = {
                    # ExclusionTags = ""
                }
            }]
        }
        "Arm" = {
            subplan = "PerSubscription"
            extensions = []
        }
        "OpenSourceRelationalDatabases" = {
            subplan = ""
            extensions = []
        }
        "Containers" = {
            subplan = ""
            extensions = [{
                name = "AgentlessDiscoveryForKubernetes"
                additional_extension_properties = {}
            },
            {
                name = "ContainerRegistriesVulnerabilityAssessments"
                additional_extension_properties = {}
            }]
        }
        "CosmosDbs" = {
            subplan = ""
            extensions = []
        }
        "CloudPosture" = {
            subplan = ""
            extensions = [{
                name = "AgentlessVmScanning"
                additional_extension_properties = {}
            },
            {
                name = "AgentlessDiscoveryForKubernetes"
                additional_extension_properties = {}
            },
            {
                name = "ContainerRegistriesVulnerabilityAssessments"
                additional_extension_properties = {}
            },
            {
                name = "SensitiveDataDiscovery"
                additional_extension_properties = {}
            }]
        }
    }

    log_retention_in_days = 30
    security_alerts_email_address = "YOUR_SUPPORT_EMAIL"
    emailSecurityContact = "YOUR_SUPPORT_EMAIL"

    # Budgeting for all subscriptions
    # Listing them here can be done with all the same values and later changed individually
    # Example:
    budget_for_subscriptions = {
        "/subscriptions/SUBSCRIPTION ID 1" = {
            name         = "SUBSCRIPTION ID 1"
            amount       = 2000
            time_grain   = "Monthly"
            start_date   = "2025-01-01T00:00:00Z"
            end_date     = "2035-01-01T00:00:00Z" # Default 10 years
            notification = local.common_notification_budget
        }
        # Add more subscriptions as needed below
    }

    common_notification_budget = {
        enabled        = true
        threshold      = 75.0
        operator       = "EqualTo"
        contact_emails = [
            local.security_alerts_email_address # Client emails can be added here too with a comma
        ] 
    }
}