{
    inputs,
    flakeRoot,
    hostsDir,
    ...
} @ args: let
    inherit (inputs) nixpkgs home-manager;

    mapFilesToAttrs = import ./map-files-to-attrs.nix nixpkgs.lib;
in
mapFilesToAttrs {
    dir = hostsDir;
    valueFn = hostname: let
        hostDir = hostsDir + /${hostname};
        argsExt = args // { inherit hostname hostDir; };
    in
    nixpkgs.lib.nixosSystem {
        system = import (hostDir + /system.nix);
        specialArgs = argsExt;
        modules = [
            (flakeRoot + /modules/nixos)
            (hostDir + /nixos/configuration.nix)
            (hostDir + /nixos/hardware-configuration.nix)
            home-manager.nixosModules.home-manager {
                home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = argsExt;
                    sharedModules = [
                        (flakeRoot + /modules/home)
                    ];
                };
            }
        ];
    };
}