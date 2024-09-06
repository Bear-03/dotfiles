{ pkgs, ... } @ inputs:
let
    domains = (import ./vars.nix).domains;
    secrets = (import ../secrets.nix);
in
{
    systemd.user.services.glances = {
        # Connections plugin has to be disabled or else grances crashes after ~2h.
        # See: https://github.com/nicolargo/glances/issues/2493
        script = ''
            ${pkgs.glances}/bin/glances -w --disable-webui --disable-plugin connections
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
                    glances-base-cfg = {
                        type = "glances";
                        url = "http://localhost:61208";
                        version = 4;
                    };
                in
                [
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
                        "CPU" = {
                            widget = glances-base-cfg // {
                                metric = "cpu";
                            };
                        };
                    }
                    {
                        "RAM" = {
                            widget = glances-base-cfg // {
                                metric = "memory";
                            };
                        };
                    }
                    {
                        "Network" = {
                            widget = glances-base-cfg // {
                                metric = "network:wlan0";
                            };
                        };
                    }
                    {
                        "Root Drive" = {
                            widget = glances-base-cfg // {
                                metric = "disk:mmcblk0";
                            };
                        };
                    }
                    {
                        "Main Drive" = {
                            widget = glances-base-cfg // {
                                metric = "disk:sda";
                            };
                        };
                    }
                ];
            }
        ];
    };
}