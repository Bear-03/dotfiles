let
    domain = "bearspi.duckdns.org";
in
{
    networking.firewall.allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
    ];

    networking.firewall.allowedUDPPorts = [
        # Jellyfin server discovery within private network
        1900 # Service discovery
        7359 # Client discovery
    ];

    services.caddy = {
        enable = true;
        virtualHosts."jelly.${domain}".extraConfig = ''
            reverse_proxy localhost:8096
        '';
    };
}