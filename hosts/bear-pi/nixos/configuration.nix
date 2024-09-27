{ config, pkgs, inputs, hostname, flakeRoot, ... }: let
    inherit (inputs) nixos-hardware;
in
{
    imports = [
        nixos-hardware.nixosModules.raspberry-pi-4
        ./caddy.nix
        ./jellyfin.nix
        ./homepage.nix
        ./wireguard.nix
        ./adguard.nix
    ];

    boot = {
        supportedFilesystems = [ "ntfs" ];
        loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
        };
    };

    hardware = {
        raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        deviceTree = {
            enable = true;
            filter = "*rpi-4-*.dtb";
        };
    };

    networking = {
        hostName = hostname;
        networkmanager.enable = true;
    };

    time.timeZone = "Europe/Madrid";

    services.openssh.enable = true;

    modules = {
        nix.enable = true;
        auto-cpufreq.enable = true;
        users = {
            enable = true;
            dir = ../users;
        };
    };

    environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
