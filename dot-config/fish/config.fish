# aliases/abbrs
alias top btop
alias vim nvim

function nd -w "nix develop"
	nix develop .#$argv --command fish
end

function np -w "nix shell"
	nix shell nixpkgs#$argv
end

function nr -w "nix run"
	nix run nixpkgs#$argv
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
