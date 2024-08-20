{ config, pkgs, usernames, hostname, flakeRoot, ... } @ inputs:
{
    imports = [
        (flakeRoot + /modules/nixos/users.nix)
        (flakeRoot + /modules/nixos/nix.nix)
    ];

    boot = {
        loader = {
            grub = {
                enable = true;
                devices = [ "nodev" ];
            };
            generic-extlinux-compatible.enable = true;
        };
    };

    networking = {
        hostName = hostname;
        networkmanager.enable = true;
    };

    time.timeZone = "Europe/Madrid";

    services = {
        openssh.enable = true;
        auto-cpufreq = {
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

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
