let
    domains = (import ./vars.nix).domains;
    secrets = (import ../secrets.nix);
    internal = cfg: ''
        @internal {
            remote_ip 192.168.1.0/24
        }

        handle @internal {
            ${cfg}
        }

        respond "Forbidden" 403
    '';
in
{
    networking.firewall.allowedTCPPorts = [
        80 # HTTP
        443 # HTTPS
    ];

    services = {
        # DynDNS Management (Refresh DNS Provider if IP changes)
        ddclient = {
            enable = true;
            protocol = "duckdns";
            ssl = false; # Enabling SSL results in an error as the IP fecther isn't available via HTTPS
            domains = [
                domains.identifier
            ];
            extraConfig = ''
                password=${secrets.duckdns-token}
            '';
        };
        caddy = {
            enable = true;

            # Homepage Dashboard
            virtualHosts."${domains.homepage}".extraConfig = ''
                reverse_proxy localhost:8082
            '';

            virtualHosts."${domains.debug}".extraConfig = ''
                templates
                respond "{{.RemoteIP}}"
            '';

            virtualHosts."${domains.adguard}".extraConfig = ''
                reverse_proxy localhost:3000
            '';

            # Jellyfin
            virtualHosts."${domains.jellyfin}".extraConfig = ''
                reverse_proxy localhost:8096
            '';

            # Wg-easy UI
            # Wireguard connections should happen at domains.base:51820
            virtualHosts."${domains.wireguard}".extraConfig = internal ''
                reverse_proxy localhost:51821
            '';

            # Jellyseerr
            # Neither Subdomains nor subfolders in URLs are supported by Jellyseerr
            # Workaround for subdomain found here: https://docs.overseerr.dev/extending-overseerr/reverse-proxy
            # Adapted fron NGINX config to Caddy
            virtualHosts."${domains.jellyseerr}".extraConfig = internal ''
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
    };
}