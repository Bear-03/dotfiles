let
    domains = (import ./vars.nix).domains;
    jellyfin-api-key = (import ../secrets.nix).jellyfin-api-key;
in
{
    services.homepage-dashboard = {
        enable = true;
        settings = {
            title = "Bear's Pi";
            color = "neutral";
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
                # TODO: Add system group with glances
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
                                key = jellyfin-api-key;
                            };
                        };
                    }
                    # TODO: Jellyseer
                ];
            }
            {
                "Network" = [
                    {
                        "Caddy" = {
                            icon = "caddy.png";
                            widget = {
                                # WARNING: This will not work with https, it needs to be http
                                url = "http://localhost:2019";
                                type = "caddy";
                            };
                        };
                    }
                ];
            }
        ];
    };
}