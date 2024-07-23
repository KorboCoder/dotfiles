#!/bin/bash
brew_path="/opt/homebrew/bin"
nix_path="$HOME/.nix-profile/bin"


if command -v "$brew_path/yabai" &> /dev/null; then
	yabai_path="$brew_path/yabai"
fi

if command -v "$nix_path/yabai" &> /dev/null; then
	yabai_path="$nix_path/yabai"
fi

if command -v "$brew_path/jq" &> /dev/null; then
	jq_path="$brew_path/jq"
fi

if command -v "$nix_path/jq" &> /dev/null; then
	jq_path="$nix_path/jq"
fi

windowid=$($yabai_path -m query --windows | $jq_path 'map(select(.app == "WezTerm" or .app == "wezterm-gui")) | sort_by(.id) | last' | $jq_path '.id')
echo "$windowid"
$yabai_path -m window "$windowid" --grid 1:1:0:0:1:1 --display 1 --focus
