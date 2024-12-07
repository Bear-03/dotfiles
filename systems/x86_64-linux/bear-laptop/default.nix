{ config, pkgs, ... } @ args:
{
    imports = [
        ./hardware.nix
        ./greetd.nix
        ./flatpak.nix
    ];

    boot = {
        # Add support for NTFS external drives
        supportedFilesystems = [ "ntfs" ];
        # Support to cross-compile NixOS images to aarch64
        binfmt.emulatedSystems = [ "aarch64-linux" ];
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    networking = {
        networkmanager.enable = true;
        # Rules needed for wireguard to work through network manager
        # Source: https://nixos.wiki/wiki/WireGuard
        firewall = {
            # If packets are still dropped, they will show up in dmesg
            logReversePathDrops = true;
            # Wireguard trips rpfilter up
            extraCommands = ''
                ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
                ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
            '';
            extraStopCommands = ''
                ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
                ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
            '';
        };
    };

    time.timeZone = "Europe/Madrid";

    i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LC_ADDRESS = "es_ES.UTF-8";
            LC_IDENTIFICATION = "es_ES.UTF-8";
            LC_MEASUREMENT = "es_ES.UTF-8";
            LC_MONETARY = "es_ES.UTF-8";
            LC_NAME = "es_ES.UTF-8";
            LC_NUMERIC = "es_ES.UTF-8";
            LC_PAPER = "es_ES.UTF-8";
            LC_TELEPHONE = "es_ES.UTF-8";
            LC_TIME = "es_ES.UTF-8";
        };
    };

    # Configure console keymap
    console.keyMap = "es";

    hardware = {
        # Enable hardware acceleration
        graphics.enable = true;
        bluetooth = {
            enable = true;
            powerOnBoot = false;
            # Enables showing battery charge
            settings.General.Experimental = true;
        };
    };

    security = {
        polkit.enable = true;
        rtkit.enable = true; # For pipewire
    };

    programs.noisetorch.enable = true;
    virtualisation.virtualbox.host.enable = true;

    services = {
        upower.enable = true; # Battery management, mainly for AGS.
        udisks2.enable = true; # Drive mounting management
        pipewire = {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = true;
        };
    };

    internal = {
        nix.enable = true;
        auto-cpufreq.enable = true;
        hyprland.enable = true;
        users."bear" = {
            extraGroups = [ "vboxusers" ];
        };
    };

    home-manager.backupFileExtension = "backup";

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
