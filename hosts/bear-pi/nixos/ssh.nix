{ hostname, ... } @ input:
{
    services.openssh.enable = true;

    # Allows remote nixos-rebuild without loging in as root
    # Source: https://github.com/NixOS/nixpkgs/issues/118655#issuecomment-1537131599
    security.sudo.extraRules = [ {
        groups = [ "wheel" ];
        commands = [ {
            command = "/run/current-system/sw/bin/nix-store";
            options = [ "NOPASSWD" ];
        } ];
    } ];
}