username: { config, pkgs, flake-root, ... } @ inputs:
{
    imports = [
        (flake-root + /modules/home/nushell.nix)
    ];

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
}
