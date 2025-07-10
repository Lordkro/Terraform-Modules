# Variables Creation for Connectivity Resources
variable "configure_connectivity_resources" {
    type = object({
        settings = object({
            hub_networks = list(
                object({
                    enabled = bool
                    config  = object({
                        address_space               = list(string)
                        location                    = string
                        linkto_ddos_protection_plan = bool
                        dns_servers                 = list(string)
                        bgp_community               = string
                        subnets                     = list(
                            object({
                                name                      = string
                                address_prefixes          = list(string)
                                network_security_group_id = string
                                route_table_id            = string
                            })
                        )
                        virtual_network_gateway = object({
                            enabled = bool
                            config  = object({
                                address_prefix           = string
                                gateway_sku_expressroute = string
                                gateway_sku_vpn          = string
                                advanced_vpn_settings    = object({
                                    enable_bgp                       = bool
                                    active_active                    = bool
                                    private_ip_address_allocation    = string
                                    default_local_network_gateway_id = string
                                    vpn_client_configuration = list(object({
                                        address_space = list(string)
                                        aad_tenant    = string
                                        aad_audience  = string
                                        aad_issuer    = string
                                        root_certficate = list(object({
                                            name             = string
                                            public_cert_data = string
                                        }))
                                        revoked_certificates = list(object({
                                            name             = string
                                            public_cert_data = string
                                        }))
                                        radius_server_address = string
                                        radius_server_secret  = string
                                        vpn_client_protocols  = list(string)
                                        vpn_auth_types        = list(string)
                                    }))
                                    bgp_settings = list(object({
                                        asn               = number
                                        peer_weight       = number
                                        peering_addresses = list(object({
                                            ip_configuration_name = string
                                            apipa_adresses        = list(string)
                                        }))
                                    }))
                                    custom_route = list(object({
                                        address_prefixes = list(string)
                                    }))
                                })
                            })
                        })
                        azure_firewall = object({
                            enabled = bool
                            config  = object({
                                address_prefix         = string
                                enable_dns_proxy       = bool
                                dns_servers            = list(string)
                                sku-tier               = string
                                base_policy_id         = string
                                private_ip_ranges      = list(string)
                                threat_intel_mode      = string
                                threat_intel_allowlist = list(string)
                                availability_zones     = object({
                                    zone1 = bool
                                    zone2 = bool
                                    zone3 = bool
                                })
                            })
                        })
                        spoke_virtual_network_resource_ids      = list(string)
                        enable_outbound_virtual_network_peering = bool
                    })
                })
            )
            vwan_hub_networks = list(object({
                enabled = bool
                config  = object({
                    address_prefix = string
                    location       = string
                    sku            = string
                    routes         = list(object({
                        address_prefixes    = list(string)
                        next_hop_ip_address = string
                    }))
                    expressroute_gateway = object({
                        enabled = bool
                        config  = object({
                            scale_unit = number
                        })
                    })
                    vpn_gateway = object({
                        enabled = bool
                        config  = object({
                            bgp_settings = list(object({
                                asn = number
                                peer_weight = number
                                instance_0_bgp_peering_address = list(object({
                                    custom_ips = list(string)
                                }))
                                instance_1_bgp_peering_address = list(object({
                                    custom_ips = list(string)
                                }))
                            }))
                            routing_preference = string
                            scale_unit = number
                        })
                    })
                    azure_firewall = object({
                        enabled = bool
                        config  = object({
                            enable_dns_proxy       = bool
                            dns_servers            = list(string)
                            sku_tier               = string
                            base_policy_id         = string
                            private_ip_ranges      = list(string)
                            threat_intel_mode      = string
                            threat_intel_allowlist = list(string)
                            availability_zones     = object({
                                zone1 = bool
                                zone2 = bool
                                zone3 = bool
                            })
                        })
                    })
                    spoke_virtual_network_resource_ids = list(string)
                    enable_virtual_hub_connections     = bool
                })
            }))
            ddos_protection_plan = object({
                enabled = bool
                config  = object({
                    location = string
                })
            })
            dns = object({
                enabled = bool
                config  = object({
                    location = string
                    enable_private_link_by_service = object({
                        azure_automation_webhook             = bool
                        azure_automation_dscandhybridworker  = bool
                        azure_sql_database_sqlserver         = bool
                        azure_synapse_analytics_sqlserver    = bool
                        azure_synapse_analytics_sql          = bool
                        storage_account_blob                 = bool
                        storage_account_table                = bool
                        storage_account_queue                = bool
                        storage_account_file                 = bool
                        storage_account_web                  = bool
                        azure_data_lake_file_system_gen2     = bool
                        azure_cosmos_db_sql                  = bool
                        azure_cosmos_db_mongodb              = bool
                        azure_cosmos_db_cassandra            = bool
                        azure_cosmos_db_gremlin              = bool
                        azure_cosmos_db_table                = bool
                        azure_database_for_postgresql_server = bool
                        azure_database_for_mysql_server      = bool
                        azure_database_for_mariadb_server    = bool
                        azure_key_vault                      = bool
                        azure_kubernetes_service_management  = bool
                        azure_search_service                 = bool
                        azure_container_registry             = bool
                        azure_app_configuration_stores       = bool
                        azure_backup                         = bool
                        azure_site_recovery                  = bool
                        azure_event_hubs_namespace           = bool
                        azure_service_bus_namespace          = bool
                        azure_iot_hub                        = bool
                        azure_relay_namespace                = bool
                        azure_event_grid_topic               = bool
                        azure_event_grid_domain              = bool
                        azure_web_apps_sites                 = bool
                        azure_machine_learning_workspace     = bool
                        signalr                              = bool
                        azure_monitor                        = bool
                        cognitive_services_account           = bool
                        azure_file_sync                      = bool
                        azure_data_factory                   = bool
                        azure_data_factory_portal            = bool
                        azure_cache_for_redis                = bool
                    })
                    private_link_locations                                 = list(string)
                    public_dns_zones                                       = list(string)
                    private_dns_zones                                      = list(string)
                    enable_private_dns_zone_virtual_network_link_on_hubs   = bool
                    enable_private_dns_zone_virtual_network_link_on_spokes = bool
                })
            })
        })
        location = any
        tags     = any
        advanced = any
    })
    description = "If specified, will customize the \"Connectivity\" landing zone settings and resources."
    default = {
        settings = {
            hub_networks = [{
                enabled = true
                config  = {
                    address_space                = ["10.156.0.0/22", ]
                    location                     = ""
                    link_to_ddos_protection_plan = false
                    dns_servers                  = []
                    bgp_community                = ""
                    subnets                      = []
                    virtual_network_gateway      = {
                        enabled = false
                        config  = {
                            address_prefix           = "10.156.0.128/26"
                            gateway_sku_expressroute = ""
                            gateway_sku_vpn          = "VpnGw1"
                            advanced_vpn_settings    = {
                                enable_bgp                       = null
                                active_active                    = null
                                private_ip_address_allocation    = ""
                                default_local_network_gateway_id = ""
                                vpn_client_configuration         = []
                                bgp_settings                     = []
                                custom_route                     = []
                            }
                        }
                    }
                    azure_firewall = {
                        enabled = false
                        config  = {
                            address_prefix                = "10.156.0.0/26"
                            enable_dns_proxy              = true
                            dns_servers                   = []
                            sku_tier                      = ""
                            base_policy_id                = ""
                            private_ip_ranges             = []
                            threat_intelligence_mode      = ""
                            threat_intelligence_allowlist = []
                            availability_zones            = {
                                zone_1 = true
                                zone_2 = true
                                zone_3 = true
                            }
                        }
                    }
                    spoke_virtual_network_resource_ids      = []
                    enable_outbound_virtual_network_peering = false
                }
            }]
            vwan_hub_networks    = []
            ddos_protection_plan = {
                enabled = false
                config  = {
                    location = ""
                }
            }
            dns = {
                enabled = true
                config  = {
                    location = ""
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
                    private_link_locations                                 = []
                    public_dns_zones                                       = []
                    private_dns_zones                                      = []
                    enable_private_dns_zone_virtual_network_link_on_hubs   = true
                    enable_private_dns_zone_virtual_network_link_on_spokes = true
                }
            }
        }
        location = null
        tags     = null

        advanced = {
            custom_settings_by_resource_type = {
                azurerm_resource_group = {
                    connectivity = {
                        "westeurope" = {
                            name = "rg-CONNECT"
                        }
                    }
                }
                azurerm_virtual_network = {
                    connectivity = {
                        "westeurope" = {
                            name = "vnet-CONNECT"
                        }
                    }
                }
            }
        }
    }
}