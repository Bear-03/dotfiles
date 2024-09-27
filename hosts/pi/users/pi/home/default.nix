username: { pkgs, flakeRoot, ... }:
{
    home = {
        inherit username;
        homeDirectory = "/home/${username}";

        packages = with pkgs; [
            neovim
            git
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
