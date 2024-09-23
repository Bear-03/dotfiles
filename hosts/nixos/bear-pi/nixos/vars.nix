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
        prowlarr = "prowlarr.${base}";
        radarr = "radarr.${base}";
        sonarr = "sonarr.${base}";
        deluge = "deluge.${base}";

        # These won't be accessed by anything outside of the config so
        # so they can't remain without a domain name
        caddy = "localhost:2019";
        glances = "localhost:61208";
    };
}