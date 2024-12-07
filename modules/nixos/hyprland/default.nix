{
    namespace,
    lib,
    config,
    ...
}:
with lib;
let
    cfg = config.${namespace}.hyprland;
in
{
    options.${namespace}.hyprland = {
        enable = mkEnableOption "Hyprland NixOS module";
    };

    config = mkIf cfg.enable {
        programs.hyprland = {
            enable = true;
            xwayland.enable = true;
        };
    };
}
