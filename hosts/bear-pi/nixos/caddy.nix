let
    domain = "192.168.1.151"; # TODO: Change to domain
in
{
    networking.firewall.allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        8096 # Jellyfin TODO: Remove, only useful because some clients dont let you use IPs without that exact port
    ];

    networking.firewall.allowedUDPPorts = [
        1900 # Jellyfin service discovery
        7359 # Jellyfin client discovery
    ];

    services.caddy = {
        enable = true;
        # Set up "jellyfin." subdomain when it is changed to an actual domain
        virtualHosts."${domain}".extraConfig = ''
            reverse_proxy localhost:8096
            tls internal # Change when using an actual domain
        '';
    };
}