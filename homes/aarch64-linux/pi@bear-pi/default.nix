{ pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            neovim
            git
            neofetch
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

    beardots.nushell.enable = true;
}
