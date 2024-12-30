# Config file for the bootlable ISO for the system
# nix build path:.#sd-aarch64-installerConfigurations.server-pi
# The result will be in the result/ directory
{
    pkgs,
    lib,
    ...
}:
{
    sdImage.compressImage = false;

    # Enable SSH in the boot process.
    systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    services.openssh.settings.PermitRootLogin = "yes";
    users.users.root = {
        initialPassword = "pass";
        initialHashedPassword = lib.mkForce null;
    };

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    environment.systemPackages = with pkgs; [
        neovim
        git
    ];

    system.stateVersion = "24.05";
}
