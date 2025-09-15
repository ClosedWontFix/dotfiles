# -*- bash -*-
# vim: ft=bash
#
# File: ~/.bash_profile
# Author: Dan Borkowski
#

# Only run in interactive login shells
[[ $- == *i* ]] || return

# Source POSIX-style profile (login env setup)
[[ -r "$HOME/.profile" ]] && . "$HOME/.profile"

# Source Bash interactive config
[[ -r "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

