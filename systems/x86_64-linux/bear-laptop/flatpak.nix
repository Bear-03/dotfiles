{ pkgs, inputs, ... }:
let
    inherit (inputs) nix-flatpak;
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
        ];
        packages = [
            {
                appId = "org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/24.08";
                origin = "flathub";
            }
            {
                flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
                sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
            }
        ];
        overrides.global = {
            Environment = {
                MANGOHUD = "1";
            };
            Context = {
                filesystems = [
                    "/home:ro"
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