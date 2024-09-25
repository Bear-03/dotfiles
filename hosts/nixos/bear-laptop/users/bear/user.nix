username: { pkgs, ... }:
{
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [ "audio" "storage" "networkmanager" "wheel" ];
    packages = with pkgs; [
        lxqt.lxqt-policykit # Polkit support
        adw-gtk3 # Adwaita theme for gtk
        adwaita-icon-theme # Cursor theme
        neofetch
        xorg.xlsclients # List all windows using XWayland
        brightnessctl # Brightness control, to be used primarily by AGS
        sassc # SCSS compiler for AGS
        pavucontrol # Audio controller
        hyprshot # Screenshots in wayland
        bluetuith # Bluetooth TUI
        vesktop # Third-party discord client with screensharing
        telegram-desktop
        trash-cli # Trashcan management
        p7zip # 7zip tools
        zip
        unzip
        zstd # .zst file management, for building some types of nixos images
        nixos-generators # NixOS image builder helper
        gcc-unwrapped
        qbittorrent
        vlc
        jellyfin-media-player
        globalprotect-openconnect # VPN manager for uni network
    ];
}
