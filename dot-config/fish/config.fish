# aliases/abbrs
alias top btop
alias vim nvim

alias nd "nix develop --command fish"
function ns -w "nix shell" -a package
	nix shell nixpkgs#$package
end

abbr -a L --position anywhere --set-cursor "% &| less"

# colors
set fish_color_user cyan
set fish_color_cwd cyan

# vim
fish_vi_key_bindings
fish_vi_cursor

# other
zoxide init fish | source
