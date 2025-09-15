# -*- zsh -*-
# vim: ft=zsh
#
# File: ~/.zprofle
# Author: Dan Borkowski
#

# Only run in interactive login shells
[[ -o interactive ]] || return

# Source POSIX-style profile (login env setup)
[[ -r "$HOME/.profile" ]] && source "$HOME/.profile"

# Source zsh interactive config
[[ -r "$HOME/.zshrc" ]] && source "$HOME/.zshrc"

