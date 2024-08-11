{ pkgs, ... } @ inputs:
{
    programs = {
        nushell = {
            enable = true;
            configFile.source = ../nushell/config.nu;
        };

        carapace = {
            enable = true;
            enableNushellIntegration = true;
        };

        starship = {
            enable = true;
            settings = {
                add_newline = false;
                hostname = {
                    ssh_only = false;
                    format = "@(bold blue)[hostname](bold red) ";
                };
                username = {
                    style_user = "yellow bold";
                    style_root = "black bold";
                    format = "[$user]($style)";
                    show_always = true;
                };
                character = {
                    success_symbol = "[ ✓](bold white)";
                    error_symbol = "[ ✗](bold red) ";
                };
                directory = {
                    truncate_to_repo = false;
                };
            };
        };

        ripgrep.enable = true;
        bat.enable = true;
    };
}