let
  withPrettier = name: ext: {
    inherit name;
    formatter = {
      command = "prettier";
      args = [
        "--stdin-filepath"
        ("." + ext)
      ];
    };
  };
in
{
  language = [
    {
      name = "rust";
      formatter = {
        command = "rustfmt";
        args = [
          "--edition"
          "2024"
        ];
      };
    }
    {
      name = "go";
      formatter = {
        command = "gofmt";
        args = [ "-e" ];
      };
    }
    {
      name = "nix";
      formatter.command = "nixfmt";
    }
    {
      name = "markdown";
      formatter = {
        command = "mdformat";
        args = [ "-" ];
      };
    }
    {
      name = "lua";
      formatter = {
        command = "stylua";
        args = [ "-" ];
      };
    }
    {
      name = "typst";
      formatter.command = "typstyle";
    }
    (withPrettier "javascript" "js")
    (withPrettier "typescript" "ts")
    (withPrettier "html" "html")
    (withPrettier "css" "css")
    (withPrettier "scss" "scss")
    (withPrettier "json" "json")
    (withPrettier "svelte" "svelte")
  ];
}
