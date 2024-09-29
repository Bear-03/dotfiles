{ namespace, config, lib, ... }:
with lib;
let
    cfg = config.${namespace}.alacritty;
in
{
    options.${namespace}.alacritty = {
        enable = mkEnableOption "Alacritty configuration";
    };

    config = mkIf cfg.enable {
        programs.alacritty = {
            enable = true;
            settings.window = {
                opacity = 0.95;
                padding = {
                    x = 5;
                    y = 5;
                };
            };
        };
    };
}