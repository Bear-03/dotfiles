username: { config, pkgs, flake-root, ... } @ inputs:
{
    imports = [
        (flake-root + /modules/home/nushell.nix)
        ./theme.nix
        ./hyprland.nix
        ./alacritty.nix
        ./git.nix
        ./ags.nix
        ./udiskie.nix
        ./flatpak.nix
    ];

    home = {
        inherit username;
        homeDirectory = "/home/${username}";

        packages = with pkgs; [
            vim
            rofi
            firefox
        ];

        sessionVariables = {
            TERM = "alacritty";
            EDITOR = "code";
            VISUAL = "code";
            BROWSER = "firefox";

            # Fix white screen for java apps
            _JAVA_AWT_WM_NONREPARENTING = 1;
            # Fix RStudio
            QT_QPA_PLATFORM = "xcb";
            # Fix font antialiasing for java apps
            JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true";
            # Fix images in WGPU apps
            WGPU_BACKEND = "vulkan";
        };

        file.".config/rofi" = {
            source = ../rofi;
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

    services = {
        swaync.enable = true;
    };
}
