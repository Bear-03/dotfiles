{
    domains = rec {
        duckdns-identifier = "bearspi";
        base = "${duckdns-identifier}.duckdns.org";
        debug = "debug.${base}";
        jellyfin = "jelly.${base}";
        jellyseerr = "seerr.${base}";
    };
}