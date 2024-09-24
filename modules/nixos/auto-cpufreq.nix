{ config, lib, ...}:
with lib;
let
    cfg = config.modules.auto-cpufreq;
in
{
    options.modules.auto-cpufreq = {
        enable = mkEnableOption "Auto-cpufreq configuration";
    };

    config = mkIf cfg.enable {
        services.auto-cpufreq = {
            enable = true;
            settings = {
                charger = {
                    governor = "performance";
                    turbo = "auto";
                };
                battery = {
                    governor = "powersave";
                    turbo = "auto";
                };
            };
        };
    };
}