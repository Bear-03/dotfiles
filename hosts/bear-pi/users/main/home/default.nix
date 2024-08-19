username: { config, pkgs, flakeRoot, ... } @ inputs:
{
    imports = [
        (flakeRoot + /modules/home/nushell.nix)
    ];

    home = {
        inherit username;
        homeDirectory = "/home/${username}";

        packages = with pkgs; [
            vim
            git
        ];

        sessionVariables = {
            EDITOR = "vim";
            VISUAL = "vim";
        };

        stateVersion = "24.05";
    };

    programs = {
        home-manager.enable = true;
        bottom.enable = true;
    };
}
