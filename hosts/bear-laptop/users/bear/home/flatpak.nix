{ config, sober, declarative-flatpak, ... } @ inputs:
let
    sober-home-path = ".cache/sober.flatpakref";
in
{
    imports = [
        declarative-flatpak.homeManagerModules.default
    ];

    # Flake input creates file with random hash, but declarative-nix
    # only detects out-of-repo files if they end in .flatpakref
    # so we have to create a symlink.
    home.file.${sober-home-path}.source = sober.outPath;

    services.flatpak = {
        packages = [
            ":${config.home.homeDirectory}/${sober-home-path}"
        ];
        overrides = {
            "global" = {
                filesystems = [
                    "home"
                ];
                environment = {
                    "MOZ_ENABLE_WAYLAND" = 1;
                };
                sockets = [
                    "!x11"
                    "fallback-x11"
                ];
            };
        };
    };
}