#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)
XDG_CONFIG_HOME="$HOME/.config"

[[ -n "$SCRIPT_DIR" ]] && [[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir "$XDG_CONFIG_HOME"
ln -sf "$SCRIPT_DIR"/nvim "$XDG_CONFIG_HOME"/nvim
ln -sf "$SCRIPT_DIR"/zsh "$XDG_CONFIG_HOME"/zsh
ln -sf "$SCRIPT_DIR"/tmux "$XDG_CONFIG_HOME"/tmux
ln -sf "$SCRIPT_DIR"/zsh/.zshenv "$HOME/.zshenv"
ln -sf "$SCRIPT_DIR"/alacritty "$XDG_CONFIG_HOME/alacritty"
ln -sf "$SCRIPT_DIR"/.profile "$HOME/.profile"
