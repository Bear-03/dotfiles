{ pkgs, ... }:
pkgs.mkShell {
    packages = with pkgs; [
        nixd
        nixfmt-rfc-style
        dbeaver-bin
    ];
}