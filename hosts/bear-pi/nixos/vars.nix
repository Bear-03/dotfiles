{
    domains = rec {
        base = "bearspi.duckdns.org";
        debug = "debug.${base}";
        jellyfin = "jelly.${base}";
        jellyseerr = "seerr.${base}";
    };
}