{
    domains = rec {
        duckdns-identifier = "bearspi";
        base = "${duckdns-identifier}.duckdns.org";
        wireguard = "wg.${base}";
        debug = "debug.${base}";
        jellyfin = "jelly.${base}";
        jellyseerr = "seerr.${base}";
    };
}