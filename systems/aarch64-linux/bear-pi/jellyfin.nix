{ pkgs, ... }:
let
    secrets = import ./secrets.nix;
in
{
    services = {
        jellyfin.enable = true;
        jellyseerr.enable = true;
        prowlarr.enable = true;
        radarr.enable = true;
        sonarr.enable = true;
        lidarr.enable = true;
        deluge = {
            enable = true;
            declarative = true;
            web.enable = true;
            config = {
                download_location = "/mnt/main/jellyfin/torrents";
                enabled_plugins = [ "Label" ];
                # Cannot afford to contribute more, my bandwidth is shit
                share_ratio_limit = 0.1;
            };
            # WebUI password must be set from the UI itself
            # these credentials refer to the connection auth
            authFile = pkgs.writeText "deluge-auth" ''
                ${secrets.deluge.username}:${secrets.deluge.password}:10
            '';
        };
    };

    environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
    ];
}