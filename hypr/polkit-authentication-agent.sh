#!/usr/bin/env bash

$(nix eval nixpkgs#polkit_gnome.outPath | tr -d '"')/libexec/polkit-gnome-authentication-agent-1