{ config, lib, pkgs, modulesPath, ... }:
let
    vars = import ./vars.nix;
in
{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
        extraModulePackages = [];
        kernelModules = [];
        initrd = {
            availableKernelModules = [ "xhci_pci" ];
            kernelModules = [];
        };
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
            fsType = "ext4";
        };
        ${vars.drives.main} = {
            device = "/dev/disk/by-uuid/180CDDD40CDDACCE";
            fsType = "ntfs";
            options = [
                "users"
                "nofail"
            ];
        };
    };

    swapDevices = [ {
        device = "/var/lib/swapfile";
        size = 2 * 1024;
    } ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.end0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}