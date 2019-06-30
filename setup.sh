#!/bin/bash

XDG_CONFIG_HOME=$HOME/.config

[[ ! -d "$XDG_CONFIG_HOME" ]] && mkdir $XDG_CONFIG_HOME
ln -sf ~/.dotfiles/nvim $XDG_CONFIG_HOME/nvim
ln -sf ~/.dotfiles/zsh $XDG_CONFIG_HOME/zsh
ln -sf ~/.dotfiles/tmux $XDG_CONFIG_HOME/tmux
ln -sf ~/.dotfiles/zsh/.zshenv ~/.zshenv
ln -sf ~/.dotfiles/nvim/init.vim ~/.vimrc
