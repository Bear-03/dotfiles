{ flake-root, hosts-dir }: let
    hostnames = builtins.attrNames (builtins.readDir hosts-dir);
    get-host-config = hostname: let
        host-dir = "${hosts-dir}/${hostname}";
        # Users of this host
        usernames = builtins.attrNames (builtins.readDir (host-dir + /users));
        inputs-ext = inputs // {
            inherit hostname;
            inherit usernames;
            inherit flake-root;
            inherit host-dir;
        };
    in
    {
        name = hostname;
        value = nixpkgs.lib.nixosSystem {
            system = import (host-dir + /arch.nix);
            specialArgs = inputs-ext;
            modules = [
                (flake-root + /modules/nixos/users.nix)
                (host-dir + /nixos/configuration.nix)
                (host-dir + /nixos/hardware-configuration.nix)
                home-manager.nixosModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        extraSpecialArgs = inputs-ext;

                        # Iterate users of the host to link all their home config files
                        users = let
                            get-user-home-config = username: let
                                home-path = host-dir + /users/${username}/home;
                            in
                            # If it isn't present, add null as placeholder, will be filtered out later
                            if builtins.pathExists home-path then {
                                name = username;
                                value = import home-path username;
                            } else null;
                        in
                        builtins.listToAttrs (
                            builtins.filter (x: x != null)
                            (map get-user-home-config usernames)
                        );
                    };
                }
            ];
        };
    };
in
builtins.listToAttrs (map get-host-config hostnames)