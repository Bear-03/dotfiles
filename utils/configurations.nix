lib: let
    utilFunctions = import ./functions.nix lib;

    inherit (utilFunctions) mapFilesToAttrs flattenAttrs;
in
{
    nixos = {
        flakeRoot,
        hostsDir,
        nixpkgs,
        home-manager,
        ...
    } @ inputs:
    mapFilesToAttrs {
        dir = hostsDir;
        valueFn = hostname: let
            hostDir = hostsDir + /${hostname};
            # Users of this host
            inputs-ext = inputs // {
                inherit hostname;
                inherit hostDir;
            };
        in
        nixpkgs.lib.nixosSystem {
            system = import (hostDir + /system.nix);
            specialArgs = inputs-ext;
            modules = [
                (flakeRoot + /modules/nixos/users.nix)
                (hostDir + /nixos/configuration.nix)
                (hostDir + /nixos/hardware-configuration.nix)
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = inputs-ext;

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

    # home-manager switch --flake .#myprofile
    home = {
        flakeRoot,
        hostsDir,
        nixpkgs,
        home-manager,
        ...
    } @ inputs:
    flattenAttrs {
        sep = "@";
        reverse = true;
        attrs = mapFilesToAttrs {
            dir = hostsDir;
            valueFn = hostname: let
                hostDir = hostsDir + /${hostname};
                usersDir = hostDir + /users;
                inputs-ext = inputs // {
                    inherit hostname;
                    inherit hostDir;
                };
            in
            mapFilesToAttrs {
                dir = usersDir;
                valueFn = username: let
                    system = import (hostDir + /system.nix);
                in
                home-manager.lib.homeManagerConfiguration {
                    pkgs = import nixpkgs.legacyPackages.${system};
                    specialArgs = inputs-ext;
                    modules = [
                        (usersDir + /${username}/home)
                    ];
                };
            };
        };
    };
}