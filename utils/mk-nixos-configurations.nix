{
    inputs,
    flakeRoot,
    hostsDir,
    ...
} @ args: let
    inherit (inputs) nixpkgs home-manager;
    inherit (nixpkgs) lib;

    mapFilesToAttrs = import ./map-files-to-attrs.nix lib;
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
            hostDir
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