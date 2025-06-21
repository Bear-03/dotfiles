{ pkgs, lib, ... }:
pkgs.mkShell {
    name = "python-generic";
    packages = with pkgs; [
        uv
    ];

    LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];
}
