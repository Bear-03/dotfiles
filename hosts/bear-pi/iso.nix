# Config file for the bootlable ISO for the system
# Made following https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
# Command:
# nixos-generate -f sd-aarch64-installer -c hosts/bear-pi/iso.nix --system aarch64-linux -o <path-to-result>
# The result is a symlink to the actual folder containing the built components, so it cannot already exist.
{ config, pkgs, lib, ... }:
{
    # Enable SSH in the boot process.
    systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    users.users.nixos = {
        initialPassword = "pass";
        initialHashedPassword = lib.mkForce null;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        neovim
    ];

    system.stateVersion = "24.05";
}
