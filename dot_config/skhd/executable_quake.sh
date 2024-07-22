#!/bin/bash

# Reference/ https://github.com/wez/wezterm/issues/1751#issuecomment-2145978901
#
set -euo pipefail

function getWeztermWindow(){
	yabai -m query --windows | jq 'map(select(.app == "WezTerm" or .app == "wezterm-gui")) | sort_by(.id) | last'
}

function updateWindowProps(){

  yabai -m window "$1" --display 1 --focus
  yabai -m window "$1" --grid 1:1:0:0:1:1
  if [ "$is_floating" = "false" ]; then
	yabai -m window "$1" --toggle float
  fi
}

window=$(getWeztermWindow)
is_visible=$(echo "$window" | jq '."is-visible"')
is_floating=$(echo "$window" | jq '."is-floating"')
id=$(echo "$window" | jq '.id')

# test if window was found, if not, open the app
if [ "$window" = "null" ]; then
  open -a "WezTerm"
  window=$(getWeztermWindow)
  updateWindowProps $id
elif [ "$is_visible" = "false" ]; then
  # if not visible, move the window to the current space and focus it
  updateWindowProps $id
else
  # if visible, hide the window
  osascript -e "tell application \"System Events\" to set visible of first process ¬" \
            -e "whose name is \"wezterm-gui\" to false"
fi
