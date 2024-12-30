let
    vars = import ./vars.nix;
    domains = vars.domains;
    secrets = import ./secrets.nix;
in
{
    services.glances.enable = true;

    services.homepage-dashboard = {
        enable = true;
        settings = {
            title = "Bear's Pi";
            color = "neutral";
            headerStyle = "boxedWidgets";
            layout = {
                "Media" = {
                    style = "row";
                    columns = 2;
                    useEqualHeights = true;
                };
                "Servarr" = {
                    style = "row";
                    columns = 2;
                    useEqualHeights = true;
                };
                "System" = {
                    style = "row";
                    columns = 3;
                    useEqualHeights = true;
                };
                "Network" = {
                    style = "row";
                    columns = 3;
                    useEqualHeights = true;
                };
            };
        };
        widgets = [
            {
                resources = {
                    label = "System";
                    cpu = true;
                    cputemp = true;
                    uptime = true;
                    memory = true;
                };
            }
            {
                resources = {
                    label = "Drives";
                    expanded = true;
                    disk = [
                        "/"
                        "/mnt/main"
                    ];
                };
            }
        ];
        services = [
            {
                "Media" = [
                    {
                        "Jellyfin" =
                            let
                                url = "https://${domains.jellyfin}";
                            in
                            {
                                icon = "jellyfin.svg";
                                href = url;
                                widget = {
                                    inherit url;
                                    type = "jellyfin";
                                    key = secrets.jellyfin.api-key;
                                };
                            };
                    }
                    {
                        "Deluge" =
                            let
                                url = "https://${domains.deluge}";
                            in
                            {
                                icon = "deluge.svg";
                                href = url;
                                widget = {
                                    inherit url;
                                    type = "deluge";
                                    password = secrets.deluge.password;
                                };
                            };
                    }
                ];
            }
            {
                "Servarr" = [
                    {
                        "Prowlarr" =
                            let
                                url = "https://${domains.prowlarr}";
                            in
                            {
                                icon = "prowlarr.svg";
                                href = url;
                                widget = {
                                    inherit url;
                                    type = "prowlarr";
                                    key = secrets.prowlarr.api-key;
                                };
                            };
                    }
                    {
                        "Radarr" =
                            let
                                url = "https://${domains.radarr}";
                            in
                            {
                                icon = "radarr.svg";
                                href = url;
                                widget = {
                                    inherit url;
                                    type = "radarr";
                                    key = secrets.radarr.api-key;
                                };
                            };
                    }
                    {
                        "Sonarr" =
                            let
                                url = "https://${domains.sonarr}";
                            in
                            {
                                icon = "sonarr.svg";
                                href = url;
                                widget = {
                                    inherit url;
                                    type = "sonarr";
                                    key = secrets.sonarr.api-key;
                                };
                            };
                    }
                    {
                        "Lidarr" =
                            let
                                url = "https://${domains.lidarr}";
                            in
                            {
                                icon = "lidarr.svg";
                                href = url;
                                widget = {
                                    inherit url;
                                    type = "lidarr";
                                    key = secrets.lidarr.api-key;
                                };
                            };
                    }
                ];
            }
            {
                "System" =
                    let
                        glances-cfg =
                            cfg:
                            cfg
                            // {
                                type = "glances";
                                url = "http://${domains.glances}";
                                version = 4;
                            };
                    in
                    [
                        {
                            "CPU" = {
                                widget = glances-cfg {
                                    metric = "cpu";
                                };
                            };
                        }
                        {
                            "RAM" = {
                                widget = glances-cfg {
                                    metric = "memory";
                                };
                            };
                        }
                        {
                            "Network" = {
                                widget = glances-cfg {
                                    metric = "network:wlan0";
                                };
                            };
                        }
                        {
                            "Processes" = {
                                widget = glances-cfg {
                                    metric = "process";
                                };
                            };
                        }
                        {
                            "Root Drive" = {
                                widget = glances-cfg {
                                    metric = "disk:mmcblk0";
                                };
                            };
                        }
                        {
                            "Main Drive" = {
                                widget = glances-cfg {
                                    metric = "disk:sda";
                                };
                            };
                        }
                    ];
            }
            {
                "Network" = [
                    {
                        "Caddy" = {
                            icon = "caddy.png";
                            widget = {
                                type = "caddy";
                                # WARNING: This will not work with https, it needs to be http
                                url = "http://${domains.caddy}";
                            };
                        };
                    }
                    {
                        "Adguard" =
                            let
                                url = "https://${domains.adguard}";
                            in
                            {
                                icon = "adguard-home.svg";
                                href = url;
                                widget = {
                                    inherit (secrets.adguard) username password;
                                    inherit url;
                                    type = "adguard";
                                };
                            };
                    }
                    {
                        "Wireguard" =
                            let
                                url = "https://${domains.wireguard}";
                            in
                            {
                                icon = "wireguard.svg";
                                href = url;
                                widget = {
                                    type = "customapi";
                                    url = "${url}/metrics/json";
                                    method = "GET";
                                    mappings = [
                                        {
                                            field = "wireguard_configured_peers";
                                            label = "Configured Peers";
                                        }
                                        {
                                            field = "wireguard_enabled_peers";
                                            label = "Enabled Peers";
                                        }
                                        {
                                            field = "wireguard_connected_peers";
                                            label = "Connected Peers";
                                        }
                                    ];
                                };
                            };
                    }
                ];
            }
        ];
    };
}
