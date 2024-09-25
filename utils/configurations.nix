lib: let
    utilFunctions = import ./functions.nix lib;

    inherit (utilFunctions) mapFilesToAttrs flattenAttrs;
in
{
    nixos = {
        inputs,
        flakeRoot,
        hostsDir,
        ...
    } @ args: let
        inherit (inputs) nixpkgs home-manager;
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

                        # Iterate users of the host to link all their home config files
                        users = mapFilesToAttrs {
                            dir = hostDir + /users;
                            valueFn = username: let
                                homePath = hostDir + /users/${username}/home;
                            in
                            # If it isn't present, add null as placeholder, will be filtered out later
                            if builtins.pathExists homePath
                            then (import homePath username)
                            else null;
                        };
                    };
                }
            ];
        };
    };

    # home-manager switch --flake .#username@hostname
    home = {
        inputs,
        flakeRoot,
        hostsDir,
        ...
    } @ args: let
        inherit (inputs) nixpkgs home-manager;
    in
    flattenAttrs {
        sep = "@";
        reverse = true;
        attrs = mapFilesToAttrs {
            dir = hostsDir;
            valueFn = hostname: let
                hostDir = hostsDir + /${hostname};
                usersDir = hostDir + /users;
                argsExt = args // { inherit hostname hostDir; };
            in
            mapFilesToAttrs {
                dir = usersDir;
                valueFn = username: let
                    system = import (hostDir + /system.nix);
                in
                home-manager.lib.homeManagerConfiguration {
                    pkgs = import nixpkgs.legacyPackages.${system};
                    specialArgs = argsExt;
                    modules = [
                        (flakeRoot + /modules/home)
                        (usersDir + /${username}/home)
                    ];
                };
            };
        };
    };
}