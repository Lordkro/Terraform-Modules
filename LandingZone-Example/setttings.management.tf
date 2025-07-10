# Management Configuration Settings
locals {
    deploy_management_resources    = false
    configure_management_resources = {
        settings = {
            log_analytics = {
                enabled = false
                config  = {
                    retention_in_days = local.log_retention_in_days
                    enable_monitoring_for_arc                   = true
                    enable_monitoring_for_vm                    = true
                    enable_monitoring_for_vmss                  = true
                    enable_solution_for_agent_health_assessment = true
                    enable_solution_for_anti_malware            = true
                    enable_solution_for_azure_activity          = true
                    enable_solution_for_change_tracking         = true
                    enable_solution_for_service_map             = true
                    enable_solution_for_sql_assessment          = true
                    enable_solution_for_updates                 = true
                    enable_solution_for_vm_insights             = true
                    enable_sentinel                             = true
                }
            }
            security_center = {
                enabled = true
                config  = {
                    email_security_contact             = local.security_alerts_email_address
                    enable_defender_for_acr            = false
                    enable_defender_for_app_services   = false
                    enable_defender_for_arm            = true
                    enable_defender_for_dns            = false
                    enable_defender_for_key_vault      = false
                    enable_defender_for_kubernetes     = false
                    enable_defender_for_oss_databases  = false
                    enable_defender_for_servers        = false
                    enable_defender_for_sql_servers    = false
                    enable_defender_for_sql_server_vms = false
                    enable_defender_for_storage        = false
                }
            }
        }
        location = local.location
        tags     = local.resource_tags
        advanced = null
    }
}