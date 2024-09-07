{ config, pkgs, nixos-hardware, usernames, hostname, flakeRoot, ... } @ inputs:
{
    imports = [
        nixos-hardware.nixosModules.raspberry-pi-4
        (flakeRoot + /modules/nixos/users.nix)
        (flakeRoot + /modules/nixos/nix.nix)
        (flakeRoot + /modules/nixos/auto-cpufreq.nix)
        ./caddy.nix
        ./jellyfin.nix
        ./homepage.nix
        ./containers.nix
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
