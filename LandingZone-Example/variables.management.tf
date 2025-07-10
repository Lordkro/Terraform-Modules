# Variables Creation for Management Resources
variable "configure_management_resources" {
    type = object({
        settings = object({
            log_analytics = object({
                enabled = bool
                config  = object({
                    retention_in_days                           = number
                    enable_monitoring_for_arc                   = bool
                    enable_monitoring_for_vm                    = bool
                    enable_monitoring_for_vmss                  = bool
                    enable_solution_for_agent_health_assessment = bool
                    enable_solution_for_anti_malware            = bool
                    enable_solution_for_azure_activity          = bool
                    enable_solution_for_change_tracking         = bool
                    enable_solution_for_service_map             = bool
                    enable_solution_for_sql_assessment          = bool
                    enable_solution_for_updates                 = bool
                    enable_solution_for_vm_insights             = bool
                    enable_sentinel                             = bool
                })
            })
            security_center = object({
                enabled = bool
                config  = object({
                    email_security_contact             = string
                    enable_defender_for_acr            = bool
                    enable_defender_for_app_services   = bool
                    enable_defender_for_arm            = bool
                    enable_defender_for_dns            = bool
                    enable_defender_for_key_vault      = bool
                    enable_defender_for_kubernetes     = bool
                    enable_defender_for_oss_databases  = bool
                    enable_defender_for_servers        = bool
                    enable_defender_for_sql_servers    = bool
                    enable_defender_for_sql_server_vms = bool
                    enable_defender_for_storage        = bool
                })
            })
        })
        location = any
        tags     = any
        advanced = any
    })

    description = "If specified, will customize management resources."
    default = {
        settings = {
            log_analytics = {
                enabled = false
                config  = {
                    retention_in_days                           = 30
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
                config = {
                    email_security_contact             = "YOURSUPPORTEMAIL"
                    enable_defender_for_acr            = true
                    enable_defender_for_app_services   = true
                    enable_defender_for_arm            = true
                    enable_defender_for_dns            = true
                    enable_defender_for_key_vault      = true
                    enable_defender_for_kubernetes     = true
                    enable_defender_for_oss_databases  = true
                    enable_defender_for_servers        = true
                    enable_defender_for_sql_servers    = true
                    enable_defender_for_sql_server_vms = true
                    enable_defender_for_storage        = true
                    enable_defender_for_containers     = true
                }
            }
        }
        location = null
        tags     = null
        advanced = null    
    }
}