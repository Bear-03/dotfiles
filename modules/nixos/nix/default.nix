{
    namespace,
    config,
    lib,
    ...
}:
with lib;
let
    cfg = config.${namespace}.nix;
in
{
    options.${namespace}.nix = {
        enable = mkEnableOption "Nix and Nixpkgs configuration";
    };

    config = mkIf cfg.enable {
        nix = {
            settings = {
                auto-optimise-store = true;
                experimental-features = [
                    "nix-command"
                    "flakes"
                ];
                trusted-users = [ "@wheel" ];

                # Yazi precompiled binaries
                extra-substituters = [ "https://yazi.cachix.org" ];
                extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
            };
            gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 1w";
            };
        };

        programs.nix-ld.enable = true;
    };
}
