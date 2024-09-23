{ config, pkgs, ... } @ inputs:
let
    secrets = (import ../secrets.nix);
in
{
    services = {
        jellyfin.enable = true;
        jellyseerr.enable = true;
        prowlarr.enable = true;
        radarr.enable = true;
        sonarr.enable = true;
        deluge = {
            enable = true;
            declarative = true;
            web.enable = true;
            config = {
                download_location = "/mnt/main/jellyfin/torrents";
                enabled_plugins = [ "Label" ];
            };
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