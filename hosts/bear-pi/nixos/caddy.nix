# let
#     domain = "bearpi.hopto.org";
# in
{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy = {
        enable = true;
        virtualHosts."https://jellyfin.${domain}".extraConfig = ''
            reverse_proxy :8096
        '';
    }
}