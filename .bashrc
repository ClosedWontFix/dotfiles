# -*- bash -*-
# vim: ft=bash
#
# File: ~/.bashrc
# Author: Dan Borkowski
#

# Load only in interactive shells
[[ $- == *i* ]] || return

# macOS quirk: unlike Linux, interactive Bash shells do not auto-source /etc/bashrc.
# Guard on Darwin to avoid double-sourcing on Linux systems.
if [[ "$(uname -s)" == "Darwin" ]] && [[ -r /etc/bashrc ]]; then . /etc/bashrc; fi

# Ensure any interactive 'sh' launched from here will also load ~/.shrc
[[ -z "${ENV:-}" ]] && ENV="$HOME/.shrc"; export ENV

# Source shared shell configuration
[[ -r "$HOME/.shrc" ]] && . "$HOME/.shrc"

# History Control
# Ignore duplicates (ignoredups) and commands that begin with a space (ignorespace)
HISTCONTROL=ignoreboth
# Number of commands to store in history cache
HISTSIZE=50000
# Number of commands to store in history file
HISTFILESIZE=10000

# Set up vi keys
set -o vi

# ----- Bash-only niceties (guarded) -----
if [[ -n "$BASH_VERSION" ]]; then
  # Bash completion
  if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif command -v brew >/dev/null 2>&1 && [ -r "$(brew --prefix)/etc/bash_completion" ]; then
    . "$(brew --prefix)/etc/bash_completion"
  fi

  # Starship prompt (optional)
  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
  fi
fi


# Local interactive overrides
[[ -r "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"
