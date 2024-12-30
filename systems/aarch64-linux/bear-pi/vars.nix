{
    local-ip = "192.168.1.2";
    drives.main = "/mnt/main";
    domains = rec {
        identifier = "bearlab";
        base = "${identifier}.duckdns.org";
        homepage = base;
        debug = "debug.${base}";
        adguard = "adguard.${base}";
        jellyfin = "jelly.${base}";
        wireguard = "wg.${base}";
        prowlarr = "prowlarr.${base}";
        radarr = "radarr.${base}";
        sonarr = "sonarr.${base}";
        lidarr = "lidarr.${base}";
        deluge = "deluge.${base}";

        # These won't be accessed by anything outside of the config so
        # so they don't need a domain name
        # TODO: Get this from config instead of hardcoding it
        caddy = "localhost:2019";
        glances = "localhost:61208";
    };
}
