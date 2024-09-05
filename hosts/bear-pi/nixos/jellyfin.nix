{ pkgs, ... } @ inputs:
{
    services = {
        jellyfin.enable = true;
        jellyseerr.enable = true;
    };
    environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
    ];
}