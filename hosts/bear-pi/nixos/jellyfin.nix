{ pkgs, ... } @ inputs:
{
    services.jellyfin.enable = true;
    environment.systemPackages = with pkgs; [
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
    ];
}