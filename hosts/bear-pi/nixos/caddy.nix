let
    domain = "192.168.8.33";
in
{
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.caddy = {
        enable = true;
        virtualHosts."http://${domain}".extraConfig = ''
            reverse_proxy localhost:8096
        '';
    };
}