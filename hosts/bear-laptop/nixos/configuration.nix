{ config, pkgs, usernames, hostname, flakeRoot, ... } @ inputs:
{
    imports = [
        (flakeRoot + /modules/nixos/users.nix)
        (flakeRoot + /modules/nixos/nix.nix)
    ];

    boot = {
        # Add support for NTFS external drives
        supportedFilesystems = [ "ntfs" ];
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    networking = {
        hostName = hostname;
        networkmanager.enable = true;
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
            settings = {
        	    General = {
                    # Enables showing battery charge
        	    	Experimental = true;
        	    };
            };
        };
    };

    security = {
        polkit.enable = true;
        rtkit.enable = true; # For pipewire
    };

    programs = {
        noisetorch.enable = true;
        hyprland = {
            enable = true;
            xwayland.enable = true;
        };
    };

    services = {
        upower.enable = true;
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
        greetd = {
            enable = true;
            settings.default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd hyprland";
            };
        };
        pipewire = {
            enable = true;
            alsa = {
                enable = true;
                support32Bit = true;
            };
            pulse.enable = true;
        };
    };

    # Mute TTY warnings showing in tuigreet
    systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal"; # Without this errors will spam on screen
        # Without these bootlogs will spam on screen
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
    };

    environment = {
        sessionVariables =  {
            # Hint electron apps to use wayland
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        };
        systemPackages = with pkgs; [
        ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
}
