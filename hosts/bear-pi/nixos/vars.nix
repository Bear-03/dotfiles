{
    local-ip = "192.168.1.2";
    domains = rec {
        identifier = "bearspi";
        base = "${identifier}.duckdns.org";
        homepage = base;
        debug = "debug.${base}";
        adguard = "adguard.${base}";
        jellyfin = "jelly.${base}";
        wireguard = "wg.${base}";
        jellyseerr = "seerr.${base}";
    };
}