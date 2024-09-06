let
    domains = (import ./vars.nix).domains;
in
{
    networking.firewall.allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
        5055
    ];

    services.caddy = {
        enable = true;

        # Homepage Dashboard
        virtualHosts."${domains.base}".extraConfig = ''
            reverse_proxy localhost:8082
        '';

        virtualHosts."${domains.debug}".extraConfig = ''
            templates
            respond "{{.RemoteIP}}" 403
        '';

        # Jellyfin
        virtualHosts."${domains.jellyfin}".extraConfig = ''
            reverse_proxy localhost:8096
        '';

        # Jellyseerr
        # Neither Subdomains nor subfolders in URLs are supported by Jellyseerr
        # Workaround for subdomain found here: https://docs.overseerr.dev/extending-overseerr/reverse-proxy
        # Adapted fron NGINX config to Caddy
        virtualHosts."${domains.jellyseerr}".extraConfig = ''
            reverse_proxy {
                to localhost:5055

                header_up Referer {http.referer}
                header_up Host {host}
                header_up X-Real-IP {remote}
                header_up X-Real-Port {remote_port}
                header_up X-Forwarded-Host {host}:{remote_port}
                header_up X-Forwarded-Server {host}
                header_up X-Forwarded-Port {remote_port}
                header_up X-Forwarded-For {remote}
                header_up X-Forwarded-Proto {scheme}
                header_up X-Forwarded-Ssl on
            }
        '';
    };
}