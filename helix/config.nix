{ lib, ... }:

with lib;
let
  mkNoOps = keys: genAttrs keys (_: "no_op");
  static =
    let

      prefix = {
        macro = "<null>";
        key = "null";
      };
      toMacroUnprefixed = genAttrs [
        "last_picker"
        "expand_selection"
        "collapse_selection"
        "flip_selections"
      ] (command: (substring 0 5 (builtins.hashString "sha1" command)));
    in
    {
      fromMacro = fold recursiveUpdate { } (
        mapAttrsToList (
          command: macro:
          fold (x: acc: { ${x} = acc; }) command ([ prefix.key ] ++ (stringToCharacters macro))
        ) toMacroUnprefixed
      );
      toMacro = mapAttrs (_: macro: prefix.macro + macro) toMacroUnprefixed;
    };
in
with static.toMacro;
{
  theme = "custom";

  editor = {
    middle-click-paste = false;
    scrolloff = 15;
    auto-format = false;
    continue-comments = false;
    file-picker.hidden = false;
    shell = [
      "fish"
      "--no-config"
      "--command"
    ];

    completion-timeout = 5;
    word-completion.trigger-length = 3;

    trim-trailing-whitespace = true;
    trim-final-newlines = true;
    default-line-ending = "lf";

    end-of-line-diagnostics = "disable";
    inline-diagnostics.cursor-line = "disable";

    soft-wrap.enable = true;
    smart-tab.enable = false;

    undercurl = true;
    bufferline = "always";
    color-modes = true;
    popup-border = "all";
    line-number = "relative";
    cursor-shape.insert = "bar";

    lsp = {
      display-signature-help-docs = false;
      display-progress-messages = true;
    };

    statusline = {
      # @TODO add version-control once helix recognizes jujutsu
      left = [
        "mode"
        "spinner"
      ];

      center = [
        "file-name"
        "read-only-indicator"
        "file-modification-indicator"
      ];

      right = [
        "diagnostics"
        "register"
        "position"
        "file-type"
      ];

      mode = {
        normal = "Normal";
        insert = "Insert";
        select = "Select";
      };
    };
  };

  keys = lib.genAttrs [ "normal" "select" ] (
    _:
    # reverse name and value
    static.fromMacro
    // {
      "+" = ":format";
      "*" = "search_selection";
      tab = "repeat_last_motion";
      "A-." = "no_op";

      # incremental selection
      ret = "expand_selection";
      "S-ret" = "shrink_selection";

      # jump to start/end of node
      "A-`" = "@${expand_selection + flip_selections + collapse_selection}";
      "`" = "@${expand_selection + collapse_selection}";

      # vim quickfix emulation
      "C-k" = "@${last_picker}<up><ret>";
      "C-j" = "@${last_picker}<down><ret>";

      # goto buffer
      "]".b = "goto_next_buffer";
      "[".b = "goto_previous_buffer";
      g = mkNoOps [
        "n"
        "p"
      ];

      space = {
        space = "file_picker";
        ret = "code_action";

        f = {
          f = "file_picker";
          F = "file_picker_in_current_buffer_directory";

          e = "file_explorer";
          E = "file_explorer_in_current_buffer_directory";

          s = "symbol_picker";
          S = "workspace_symbol_picker";

          d = "diagnostics_picker";
          D = "workspace_diagnostics_picker";

          b = "buffer_picker";
          g = "global_search";
          "'" = "last_picker";
          "?" = "command_palette";
        };

        l = {
          r = "rename_symbol";
          h = "select_references_to_symbol_under_cursor";
          a = "code_action";
          k = "hover";
          c = "toggle_comments";
        };
      }
      // mkNoOps ([
        "s"
        "r"
        "h"
        "a"
        "K"
        "c"
        "C"
        "A-c"
        "F"
        "e"
        "E"
        "b"
        "S"
        "d"
        "D"
        "j"
        "G"
        "k"
        "/"
        "?"
      ]);
    }
  );
}
