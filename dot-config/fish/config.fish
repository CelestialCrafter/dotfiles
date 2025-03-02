alias top btop
alias vim nvim
alias nd "nix develop --command fish"
abbr -a L --position anywhere --set-cursor "%--color=always &| less"

set fish_color_user cyan
set fish_color_cwd cyan

fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_visual block
set fish_cursor_insert line
set fish_cursor_external line
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore

zoxide init fish | source
