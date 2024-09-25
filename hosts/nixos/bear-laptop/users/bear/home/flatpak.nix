{ config, inputs, ... }:
let
    inherit (inputs) sober declarative-flatpak;
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
            "flathub:app/org.freedesktop.Platform.VulkanLayer.MangoHud//stable"
            ":${config.home.homeDirectory}/${sober-home-path}"
        ];
        overrides = {
            global = {
                filesystems = [
                    "home"
                ];
                environment = {
                    "MOZ_ENABLE_WAYLAND" = 1;
                    "MANGOHUD" = 1;
                };
                sockets = [
                    "!x11"
                    "fallback-x11"
                ];
            };
        };
    };
}