{
    description = "NixOS config flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";

        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        snowfall-lib = {
            url = "github:snowfallorg/lib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-generators = {
            url = "github:nix-community/nixos-generators";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-flatpak.url = "github:gmodena/nix-flatpak?ref=main";
        # TODO: Migrate to v2
        ags.url = "github:Aylur/ags/v1";
    };

    outputs =
        { home-manager, ... }@inputs:
        inputs.snowfall-lib.mkFlake {
            inherit inputs;
            src = ./.;

            snowfall.namespace = "beardots";

            systems.modules.nixos = [
                home-manager.nixosModules.home-manager
            ];

            channels-config.allowUnfree = true;

            outputs-builder = channels: {
                formatter = channels.nixpkgs.nixfmt-rfc-style;
            };
        };
}
