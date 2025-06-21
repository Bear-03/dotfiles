{
    pkgs,
    inputs,
    ...
}:
let
    inherit (inputs) nixos-hardware;
in
{
    imports = [
        nixos-hardware.nixosModules.raspberry-pi-4
        ./hardware.nix
        ./caddy.nix
        ./jellyfin.nix
        ./homepage.nix
        ./wireguard.nix
        ./adguard.nix
        ./ssh.nix
    ];

    boot = {
        supportedFilesystems = [ "ntfs" ];
        initrd.systemd.tpm2.enable = false;
        loader = {
            grub.enable = false;
            generic-extlinux-compatible.enable = true;
        };
    };

    # Enable GPU
    hardware.raspberry-pi."4".fkms-3d.enable = true;

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Madrid";

    internal = {
        nix.enable = true;
        auto-cpufreq.enable = true;
        users."pi" = {
            # A password is always needed for SSH, so we provide a default one
            initialPassword = "pass";
            extraGroups = [
                "gpio"
                "storage"
                "networkmanager"
                "wheel"
            ];
        };
    };

    environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
    ];

    system.stateVersion = "24.05";
}
