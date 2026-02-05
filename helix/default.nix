{
  pkgs,
  lib,
  wrap,
  ...
}:

let
  toToml = name: src: (pkgs.formats.toml { }).generate name src;
in
wrap "helix" (
  lib.mapAttrs' (name: value: lib.nameValuePair name (toToml name value)) {
    "config.toml" = import ./config.nix pkgs;
    "languages.toml" = import ./languages.nix;
    "themes/custom.toml" = import ./theme.nix;
  }
)
