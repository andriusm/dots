#!/bin/bash

CURDIR="$(pwd)"

link() {
	target="$HOME/.config/$1"
	if [ -d $target ]; then
		echo "Did not create link for '$1' (already exists)"
	else
		ln -s $CURDIR/$1 $target
	fi
}

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
