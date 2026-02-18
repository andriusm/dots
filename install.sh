#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
	local src="$SCRIPT_DIR/$1"
	local target="$HOME/.config/$1"

	if [ ! -d "$src" ]; then
		echo "SKIP '$1' (source does not exist)"
		return
	fi

	if [ -L "$target" ]; then
		local current
		current="$(readlink "$target")"
		if [ "$current" = "$src" ]; then
			echo "OK   '$1' (symlink already correct)"
		else
			echo "SKIP '$1' (symlink exists -> $current)"
		fi
		return
	fi

	if [ -e "$target" ]; then
		echo "SKIP '$1' (already exists and is not a symlink)"
		return
	fi

	ln -s "$src" "$target"
	echo "LINK '$1' -> $src"
}

mkdir -p "$HOME/.config"

link "lf"
link "alacritty"
link "tmux"
link "wezterm"
link "nvim"
link "git"
link "dosbox"
link "bash"
link "btop"
link "i3"
link "ghostty"
link "lazydocker"
link "newsboat"
link "zsh"
