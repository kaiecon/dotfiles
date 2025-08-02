#!/bin/sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login exists.

# ==========================================
# Environment Variables - Integrated by modernize.py
# ==========================================

# System and Login Environment
# ANDROID_AVD installation
export ANDROID_AVD_HOME="${XDG_CONFIG_HOME}/.android/avd"

# ANDROID installation
export ANDROID_HOME="$HOME/Android/Sdk"

# Default editor
export EDITOR="nvim"

# System locale
export LANG="en_US.UTF-8"

# System PATH
export PATH="\
    /home/lily/.local/share/solana/install/active_release/bin:\
    $VOLTA_HOME/bin:\
    /usr/local/sbin:\
    /usr/local/opt/llvm/bin:\
    $PATH"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# VOLTA installation
export VOLTA_HOME="$HOME/.volta"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"


# Source shell-specific configuration
# This will be handled by each shell's rc file