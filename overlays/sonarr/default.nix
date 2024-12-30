{ channels, ... }:
self: super: {
    inherit (channels.nixpkgs-old) sonarr;
}
