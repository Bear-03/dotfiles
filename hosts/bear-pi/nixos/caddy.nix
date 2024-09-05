let
    domains = (import ./vars.nix).domains;
in
{
    networking.firewall.allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
    ];

    services.caddy = {
        enable = true;
        # Homepage Dashboard
        virtualHosts."${domains.base}".extraConfig = ''
            reverse_proxy localhost:8082
        '';
        # Jellyfin
        virtualHosts."${domains.jellyfin}".extraConfig = ''
            reverse_proxy localhost:8096
        '';
    };
}