with import <nixpkgs> {};
mkShell {
  packages = [
    (python3.withPackages (python-pkgs: with python-pkgs; [
      discordpy
    ]))
  ];
}
