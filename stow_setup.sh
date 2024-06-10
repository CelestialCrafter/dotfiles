#!/bin/sh

if ! command -v stow >/dev/null 2>&1; then
	echo "You need to have GNU stow installed."
	exit 1
fi

stow --dotfiles . -t "$HOME/"
