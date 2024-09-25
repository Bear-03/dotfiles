{
    description = "NixOS config flake";

    inputs = {
        # NixOS official unstable packages
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        declarative-flatpak.url = "github:GermanBread/declarative-flatpak/stable-v3";
        ags.url = "github:Aylur/ags";

        # Roblox for linux
        sober = {
            url = "https://sober.vinegarhq.org/sober.flatpakref";
            flake = false;
        };
    };

    outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
        configurationUtils = (import ./utils/configurations.nix nixpkgs.lib);
        flakeRoot = ./.;
        args = { inherit inputs flakeRoot; };
    in
    {
        nixosConfigurations = configurationUtils.nixos (args // { hostsDir = ./hosts/nixos; });
        homeConfigurations = configurationUtils.home (args // { hostsDir = ./hosts/nix; });
    };
}
