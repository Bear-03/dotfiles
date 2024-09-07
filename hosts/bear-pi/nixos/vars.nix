{
    domains = rec {
        duckdns-identifier = "bearspi";
        base = "${duckdns-identifier}.duckdns.org";
        debug = "debug.${base}";
        wireguard = "wg.${base}";
        adguard = "adguard.${base}";
        jellyfin = "jelly.${base}";
        jellyseerr = "seerr.${base}";
    };
}