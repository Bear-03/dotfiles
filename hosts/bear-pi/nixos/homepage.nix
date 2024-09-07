{ pkgs, ... } @ inputs:
let
    vars = (import ./vars.nix);
    domains = vars.domains;
    secrets = (import ../secrets.nix);
in
{
    systemd.user.services.glances = {
        # Connections plugin has to be disabled or else grances crashes after ~2h.
        # See: https://github.com/nicolargo/glances/issues/2493
        script = ''
            ${pkgs.glances}/bin/glances -w --disable-webui --disable-plugin cloud,connections
        '';
        wantedBy = [ "multi-user.target" ];
    };

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
                        "Jellyfin" = let
                            url = "https://${domains.jellyfin}";
                        in
                        {
                            icon = "jellyfin.svg";
                            href = url;
                            widget = {
                                inherit url;
                                type = "jellyfin";
                                key = secrets.jellyfin-api-key;
                            };
                        };
                    }
                    {
                        "Jellyseerr" = let
                            url = "https://${domains.jellyseerr}";
                        in
                        {
                            icon = "jellyseerr.svg";
                            href = url;
                            widget = {
                                inherit url;
                                type = "jellyseerr";
                                key = secrets.jellyseerr-api-key;
                            };
                        };
                    }
                ];
            }
            {
                "System" = let
                    glances-cfg = cfg: cfg // {
                        type = "glances";
                        url = "http://localhost:61208";
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
                                url = "http://localhost:2019";
                            };
                        };
                    }
                    {
                        "Adguard" = let
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
                        "Wireguard" = let
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