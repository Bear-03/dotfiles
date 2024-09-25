username: args:
{
    home = {
        inherit username;
        homeDirectory = "/home/${username}";

        stateVersion = "24.05";
    };

    programs.home-manager.enable = true;

    modules = {
        nushell.enable = true;
        alacritty.enable = true;
        ags.enable = true;
        theme.enable = true;
        hyprland = {
            enable = true;
            wallpaper = ../bg.png;
        };
    };
}