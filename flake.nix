{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    with nixpkgs;
    {
      packages = lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
        system:
        let
          pkgs = legacyPackages.${system};
          scope = lib.makeScope pkgs.newScope (self: {
            wrap =
              name: paths:
              pkgs.runCommand name { } (
                lib.concatLines (
                  lib.mapAttrsToList (file: src: ''
                    mkdir -p "$out/${name}/$(dirname ${file})"
                    ln -s ${src} "$out/${name}/${file}"
                  '') paths
                )
              );
          });
        in
        rec {
          helix = scope.callPackage ./helix { };
          default = pkgs.symlinkJoin {
            name = "dotfiles";
            paths = [ helix ];
          };
        }
      );
    };
}
