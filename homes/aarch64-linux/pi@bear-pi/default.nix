{ pkgs, flakeRoot, ... }:
{
    home = {
        packages = with pkgs; [
            neovim
            git
            neofetch
            glances # Monitoring tool for homepage dashboard
            trash-cli # Trashcan management
            zip
            unzip
        ];

        sessionVariables = {
            EDITOR = "neovim";
            VISUAL = "neovim";
        };

        stateVersion = "24.05";
    };

    programs = {
        home-manager.enable = true;
        bottom.enable = true;
    };

    modules.nushell.enable = true;
}
