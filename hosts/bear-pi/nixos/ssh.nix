{ hostname, ... } @ input:
{
    services.openssh.enable = true;

    # Allows remote nixos-rebuild without loging in as root
    # Workaround for https://github.com/NixOS/nixpkgs/issues/118655
    # Source: https://discourse.nixos.org/t/remote-nixos-rebuild-sudo-askpass-problem/28830/15
    security.sudo.extraRules = let
        storePrefix = "/nix/store/*";
        systemName = "nixos-system-${hostname}-*";
    in [
        {
            groups = [ "wheel" ];
            commands = [ {
                command = "${storePrefix}-nix-*/bin/nix-env -p /nix/var/nix/profiles/system --set ${storePrefix}-${systemName}";
                options = [ "NOPASSWD" ];
            } ];
        }
        {
            groups = [ "wheel" ];
            commands = [ {
                command = "${storePrefix}-${systemName}/bin/switch-to-configuration";
                options = [ "NOPASSWD" ];
            } ];
        }
    ];
}