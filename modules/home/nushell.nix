{ config, lib, pkgs, ... } @ inputs:
with lib;
let
    cfg = config.modules.nushell;
in
{
    options.modules.nushell = {
        enable = mkEnableOption "Nushell and utility shell programs";
    };

    config = mkIf cfg.enable {
        programs = {
            nushell = {
                enable = true;
                configFile.source = ../nushell/config.nu;
            };

            # Shell commands autocomplete
            carapace = {
                enable = true;
                enableNushellIntegration = true;
            };

            # Tree replacement
            broot = {
                enable = true;
                enableNushellIntegration = true;
            };

            # Grep replacement
            ripgrep.enable = true;
            # Cat replacement
            bat.enable = true;

            # Shell file explorer
            yazi = {
                enable = true;
                enableNushellIntegration = true;
            };

            starship = {
                enable = true;
                settings = {
                    add_newline = false;
                    hostname = {
                        ssh_only = false;
                        format = "@(bold blue)[$hostname](bold red) ";
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
        };
    };
}