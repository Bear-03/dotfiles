# let
#     domain = "bearpi.hopto.org";
# in
{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy = {
        enable = true;
        virtualHosts."localhost".extraConfig = ''
            reverse_proxy localhost:8096
        '';
    };
}