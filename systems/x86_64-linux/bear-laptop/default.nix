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
        # XBOX One controller support
        xone.enable = true;
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

    programs = {
        noisetorch.enable = true;
        # Needed for heroic launcher & others
        gamescope.enable = true;
        gamemode.enable = true;
        steam = {
            enable = true;
            gamescopeSession.enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
            localNetworkGameTransfers.openFirewall = true;
        };
    };

    services = {
        upower.enable = true; # Battery management, mainly for AGS.
        udisks2.enable = true; # Drive mounting management
        globalprotect.enable = true;
        pipewire = {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = true;
        };
    };

    beardots = {
        nix.enable = true;
        auto-cpufreq.enable = true;
        hyprland.enable = true;
        users."bear" = {
            extraGroups = [ "networkmanager" ];
        };
    };

    home-manager.backupFileExtension = "backup";

    system.stateVersion = "24.05";
}
