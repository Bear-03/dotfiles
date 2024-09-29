{
    inputs,
    flakeRoot,
    hostsDir,
    ...
} @ args: let
    inherit (inputs) nixpkgs home-manager;
    inherit (nixpkgs) lib;

    filesIn = import ./files-in.nix;
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
            hostDir
            home-manager.nixosModules.home-manager {
                home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = argsExt;
                    sharedModules = filesIn false (flakeRoot + /modules/home);
                };
            }
        ]
        ++ filesIn false (flakeRoot + /modules/nixos);
    };
}