{ config, pkgs, inputs, ... }:
let
    inherit (inputs) sober nix-flatpak;

    soberPatchedPath = pkgs.writeText "sober.flatpakrepo" (
        builtins.replaceStrings ["[Flatpak Ref]"] ["[Flatpak Repo]"] (builtins.readFile sober.outPath)
    );
in
{
    imports = [
        nix-flatpak.nixosModules.nix-flatpak
    ];

    services.flatpak = {
        enable = true;
        uninstallUnmanaged = true;
        update.onActivation = true;
        remotes = [
            {
                name = "flathub";
                location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
            }
            {
                name = "sober";
                location = "file://${soberPatchedPath}";
            }
        ];
        packages = [
            { appId = "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08"; origin = "flathub"; }
            { appId = "org.vinegarhq.Sober"; origin = "sober"; }
        ];
        overrides.global = {
            Environment = {
                MANGOHUD = "1";
            };
            Context = {
                filesystems = [
                    "home:ro"
                ];
                sockets = [
                    "gpg-agent"
                    # Force Wayland by default
                    "wayland"
                    "!x11"
                    "!fallback-x11"
                ];
            };
        };
    };
}