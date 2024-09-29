{ config, pkgs, ... }:
{
    imports = [
        ./git.nix
        ./udiskie.nix
        ./flatpak.nix
    ];

    home = {
        packages = with pkgs; [
            vim
            rofi
            firefox
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
        ];

        sessionVariables = {
            TERM = "alacritty";
            EDITOR = "code";
            VISUAL = "code";
            BROWSER = "firefox";
        };

        file.".config/rofi" = {
            source = ./rofi;
            recursive = true;
        };

        stateVersion = "24.05";
    };

    programs = {
        vscode.enable = true;
        home-manager.enable = true;
        rofi.enable = true;
        bottom.enable = true;
    };

    internal = {
        nushell.enable = true;
        alacritty.enable = true;
        ags.enable = true;
        theme.enable = true;
        hyprland = {
            enable = true;
            wallpaper = ./bg.png;
        };
    };
}
