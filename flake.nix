{
    description = "NixOS config flake";

    inputs = {
        # NixOS official unstable packages
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        ags.url = "github:Aylur/ags";
    };

    outputs = { self, nixpkgs, home-manager, ... } @ inputs : {
        nixosConfigurations = let
            hostnames = builtins.attrNames (builtins.readDir ./hosts);
            flakeRoot = ./.;
        in
        # Iterate all hostnames and generate config for each one of them
        # based on folder structure
        builtins.listToAttrs (map (hostname: let
            host-dir = ./hosts/${hostname};
            # Users of this host
            usernames = builtins.attrNames (builtins.readDir (host-dir + /users));
            inputs-ext = inputs // {
                inherit hostname;
                inherit usernames;
                inherit flakeRoot;
            };
        in
        {
            name = hostname;
            value = nixpkgs.lib.nixosSystem {
                system = import (host-dir + /arch.nix);
                specialArgs = inputs-ext;
                modules = [
                    (host-dir + /nixos/configuration.nix)
                    (host-dir + /nixos/hardware-configuration.nix)
                    home-manager.nixosModules.home-manager {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            extraSpecialArgs = inputs-ext;

                            # Iterate users of the host to link all their home config files
                            users = builtins.listToAttrs
                                # Filter out all nulls
                                (builtins.filter (x: x != null) (map (username:
                                    let
                                        home-path = host-dir + /users/${username}/home;
                                    in
                                    # If it isn't present, add null as placeholder, will be filtered out later
                                    if builtins.pathExists home-path then {
                                        name = username;
                                        value = import home-path username;
                                    } else null) usernames));
                        };
                    }
                ];
            };
        }) hostnames);
    };
}
