let
    vars = (import ./vars.nix);
in
{
    networking = {
        nameservers = [
            "127.0.0.1" # Also use adguard on this machine
            "1.1.1.1"
            "1.0.0.1"
        ];
        firewall = {
            allowedTCPPorts = [ 53 ];
            allowedUDPPorts = [ 53 ];
        };
    };

    services.adguardhome = {
        enable = true;
        settings = {
            dns = {
                upstream_dns = [
                    "1.1.1.1"
                    "1.0.0.1"
                ];
                fallback_dns = [
                    "8.8.8.8"
                    "8.8.4.4"
                ];
            };
            filtering.rewrites = [
                {
                    domain = "${vars.domains.base}";
                    answer = vars.local-ip;
                }
                {
                    domain = "*.${vars.domains.base}";
                    answer = vars.local-ip;
                }
            ];
        };
    };
}