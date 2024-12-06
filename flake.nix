{
    description = "NixOS config flake";

    inputs = {
        # NixOS official unstable packages
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        snowfall-lib = {
            url = "github:snowfallorg/lib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
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

    outputs = { home-manager, ... } @ inputs:
    inputs.snowfall-lib.mkFlake {
        inherit inputs;
        src = ./.;

        snowfall.namespace = "internal";

        systems.modules.nixos = [
            home-manager.nixosModules.home-manager
        ];
    };
}
