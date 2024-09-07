{
    networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
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
        };
    };
}