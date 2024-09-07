{
    local-ip = "192.168.1.2";
    domains = rec {
        identifier = "bearspi";
        external-base = "${identifier}.duckdns.org";
        internal-base = "${identifier}.lan";
        homepage = external-base;
        debug = "debug.${external-base}";
        adguard = "adguard.${external-base}";
        jellyfin = "jelly.${external-base}";
        wireguard = "wg.${internal-base}";
        jellyseerr = "seerr.${internal-base}";
    };
}