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
  languages = [
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
      formatter = {
        command = "nixfmt";
      };
    }
    {
      name = "markdown";
      formatter = {
        command = "mdformat";
        args = [ "-" ];
      };
    }
    (withPrettier "javascript" "js")
    (withPrettier "typescript" "ts")
    (withPrettier "html" "html")
    (withPrettier "css" "css")
    (withPrettier "scss" "scss")
    (withPrettier "json" "json")
    {
      name = "lua";
      formatter = {
        command = "stylua";
        args = [ "-" ];
      };
    }
    (withPrettier "svelte" "svelte")
  ];
}
