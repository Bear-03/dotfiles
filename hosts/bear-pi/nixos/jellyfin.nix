{ pkgs, ... } @ inputs:
{
    services.jellyfin = {
        enable = true;
        dataDir = "/mnt/main/jellyfin";
    };

    environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
    ];
}