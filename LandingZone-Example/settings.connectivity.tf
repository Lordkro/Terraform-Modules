# Connectivity Resource Settings configuration

# Root Certificate - Self-Signed P2S Root CA
variable "root_certificate" {
    type = object({
        name             = string
        root_certificate = list(object({
            name             = string
            public_cert_data = string
        }))
        aad_audience          = string
        aad_issuer            = string
        aad_tenant            = string
        address_space         = list(string)
        radius_server_address = string
        radius_server_secret  = string
        revoked_certificates  = list(object({
            name             = string
            public_cert_data = string
        }))
        vpn_auth_types       = list(string)
        vpn_client_protocols = list(string)
    })
    default = {
        name = "SelfSigned-P2S-Root-CA"
        root_certificate = [{
            name = "SelfSigned-P2S-Root-CA"
            public_cert_data = <<EOF
                    MIIC5zCCAc+gAwIBAgIQFi/fiiIk2YlN1gzuYoGkqjANBgkq............
                    .............
                    .............
                    .............
                    .............
                    EOF
        }]
        aad_audience          = null
        aad_issuer            = null
        aad_tenant            = null
        address_space         = ["10.0.3.0/24"] # Example address space
        radius_server_address = null
        radius_server_secret  = null
        revoked_certificates  = []
        vpn_auth_types        = []
        vpn_client_protocols  = []
    }
}

# Local variable declaration for connectivity settings
locals {
    deploy_connectivity_resources    = true
    configure_connectivity_resources = {
        settings = {
            hub_networks = [{
                enabled  = true
                config   = {
                    address_space          = ["10.248.250.0/24"]
                    location               = local.location
                    linkto_ddos_protection = false
                    dns_servers            = ["10.247.224.5", "10.247.224.6"]
                    bgp_community          = ""
                    subnets                = [{
                        # Landing Zone not deploying Firewall by default, 
                        # so we have to specify the subnet
                        name                      = "AzureFirewallSubnet"
                        address_prefixes          = ["10.248.250.0/26"]
                        network_security_group_id = null
                        route_table_id            = null
                    }]

                    # Virtual Network Gateway example configuration
                    # Currently Disabled
                    virtual_network_gateway = {
                        enabled = false
                        config = {
                            address_prefix           = "10.150.1.0/24"
                            gateway_sku_expressroute = ""
                            gateway_sku_vpn          = "VpnGw1"
                            advanced_vpn_settings = {
                                enable_bgp                       = null
                                active_active                    = null
                                private_ip_address_allocation    = ""
                                default_local_network_gateway_id = ""
                                vpn_client_configuration         = [var.root_certificate]
                                bgp_settings                     = []
                                custom_routes                    = []
                            }
                        }
                    }

                    # Virtual Firewall example configuration
                    # Note: Firewall not deployed here by default, just added as example
                    # Currently Disabled
                    azure_firewall = {
                        enabled = false
                        config = {
                            address_prefix = "0.0.0.0/24" # Example address prefix
                            enabled_dns_proxy = true
                            dns_servers = []
                            sku_tier = ""
                            base_policy_id = ""
                            private_ip_ranges = []
                            threat_intel_mode = ""
                            threat_intel_allowlist = []
                            availability_zones = {
                                zone_1 = true
                                zone_2 = true
                                zone_3 = true
                            }
                        }
                    }

                    spoke_virtual_network_resource_ids = []
                    enable_outbound_virtual_network_peering = true
                }
            }]

            vwan_hub_network = []

            # DDOS Protection configuration
            # Note: Very client specific, so not enabled by default
            # Currently Disabled
            ddos_protection_plan = {
                enabled = false
                config = {
                    location = local.location
                }
            }

            # DNS Configuration
            # Note: DNS not deployed here by default, just added as example
            # Currently Disabled
            dns = {
                enabled = false
                config  = {
                    location                       = null
                    enable_private_link_by_service = {
                        azure_automation_webhook             = true
                        azure_automation_dscandhybridworker  = true
                        azure_sql_database_sqlserver         = true
                        azure_synapse_analytics_sqlserver    = true
                        azure_synapse_analytics_sql          = true
                        storage_account_blob                 = true
                        storage_account_table                = true
                        storage_account_queue                = true
                        storage_account_file                 = true
                        storage_account_web                  = true
                        azure_data_lake_file_system_gen2     = true
                        azure_cosmos_db_sql                  = true
                        azure_cosmos_db_mongodb              = true
                        azure_cosmos_db_cassandra            = true
                        azure_cosmos_db_gremlin              = true
                        azure_cosmos_db_table                = true
                        azure_database_for_postgresql_server = true
                        azure_database_for_mysql_server      = true
                        azure_database_for_mariadb_server    = true
                        azure_key_vault                      = true
                        azure_kubernetes_service_management  = true
                        azure_search_service                 = true
                        azure_container_registry             = true
                        azure_app_configuration_stores       = true
                        azure_backup                         = true
                        azure_site_recovery                  = true
                        azure_event_hubs_namespace           = true
                        azure_service_bus_namespace          = true
                        azure_iot_hub                        = true
                        azure_relay_namespace                = true
                        azure_event_grid_topic               = true
                        azure_event_grid_domain              = true
                        azure_web_apps_sites                 = true
                        azure_machine_learning_workspace     = true
                        signalr                              = true
                        azure_monitor                        = true
                        cognitive_services_account           = true
                        azure_file_sync                      = true
                        azure_data_factory                   = true
                        azure_data_factory_portal            = true
                        azure_cache_for_redis                = true
                    }
                    private_link_locations = []
                    public_dns_zones = []
                    private_dns_zones = []
                    enable_private_dns_zone_virtual_network_link_on_hubs   = true
                    enable_private_dns_zone_virtual_network_link_on_spokes = true
                }
            }
        }

        # Example: Overriding default naming convention => Advanced Settings of connectivty module
        location = local.location
        tags     = local.resource_tags
        advanced = {
            custom_settings_by_resource = {
                azurerm_resource_group = {
                    connectivity = {
                        "westeurope" = {
                            name = "rg-hub-scon-prd-01"
                        }
                    }
                }
                azurerm_virtual_network = {
                    connectivity = {
                        "westeurope" = {
                            name = "vnet-hub-scon-prd-01"
                        }
                    }
                }
                azurerm_subnet = {
                    connectivity = {
                        "westeurope" = {
                            "AzureFirewallSubnet" = {
                                service_endpoints = [ "Microsoft.Storage" ]
                            }
                        }
                    }
                }
            }
        }
    }
}