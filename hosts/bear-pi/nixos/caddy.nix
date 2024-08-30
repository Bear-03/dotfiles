let
    domain = "192.168.1.151"; # TODO: Change to domain
in
{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy = {
        enable = true;
        # Set up "jellyfin." subdomain when it is changed to an actual domain
        virtualHosts."${domain}".extraConfig = ''
            reverse_proxy localhost:8096
            tls internal # Change when using an actual domain
        '';
    };
}