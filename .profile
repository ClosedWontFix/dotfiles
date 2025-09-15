# -*- sh -*-
# vim: ft=sh
#
# File: ~/.profile
# Author: Dan Borkowski
#

# Locale & umask
[ -z "${LANG:-}" ] && LANG=en_US.UTF-8
export LANG
umask 022

# XDG base dirs (fallbacks)
[ -n "$XDG_CONFIG_HOME" ] || XDG_CONFIG_HOME="$HOME/.config"
[ -n "$XDG_CACHE_HOME"  ] || XDG_CACHE_HOME="$HOME/.cache"
[ -n "$XDG_STATE_HOME"  ] || XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_STATE_HOME

# History (portable: ash supports HISTFILE/HISTSIZE; ignore features not universal)
HISTDIR="$XDG_STATE_HOME/sh"
[ -d "$HISTDIR" ] || mkdir -p "$HISTDIR"
[ -n "$HISTFILE" ] || HISTFILE="$HISTDIR/history"
[ -n "$HISTSIZE" ] || HISTSIZE=5000
export HISTFILE HISTSIZE

# Ensure a login umask
umask 022

# Reuse or start ssh-agent (skip when inside SSH)
agent_env="$HOME/.ssh/agent.env"

# Inside SSH? Don't spawn a local agent.
if [ -z "$SSH_CONNECTION" ]; then
  # If an agent is already exported and reachable, keep it.
  if [ -S "$SSH_AUTH_SOCK" ] && ssh-add -l >/dev/null 2>&1; then
    :
  else
    # Try to reuse a previously saved agent
    if [ -r "$agent_env" ]; then
      # shellcheck source=/dev/null
      . "$agent_env"
      # Validate the sourced agent; if bad, unset and start fresh
      if ! [ -S "$SSH_AUTH_SOCK" ] || ! ssh-add -l >/dev/null 2>&1; then
        unset SSH_AUTH_SOCK SSH_AGENT_PID
      fi
    fi

    # If still no valid agent, start one and save its env
    if [ -z "$SSH_AUTH_SOCK" ]; then
      eval "$(ssh-agent -s)" >/dev/null
      umask 077
      mkdir -p "$HOME/.ssh"
      {
        printf 'SSH_AUTH_SOCK=%s; export SSH_AUTH_SOCK;\n' "$SSH_AUTH_SOCK"
        printf 'SSH_AGENT_PID=%s; export SSH_AGENT_PID;\n' "$SSH_AGENT_PID"
      } > "$agent_env"
    fi
  fi
fi

# POSIX login env only (PATH, exports). Do NOT source .shrc here.
# Make *interactive* POSIX sh load ~/.shrc automatically
[ -z "${ENV:-}" ] && ENV="$HOME/.shrc"
export ENV

# De-duplicate PATH (pure POSIX)
dedup_path() {
  old_IFS=$IFS
  IFS=:
  set -f            # disable globbing
  # shellcheck disable=SC2086  # intentional splitting of $PATH
  set -- $PATH      # split PATH on ':'
  set +f            # re-enable globbing
  IFS=$old_IFS

  new=""
  for d in "$@"; do
    [ -z "$d" ] && continue
    case ":$new:" in
      *":$d:"*) ;;  # already present
      *) new="${new:+$new:}$d" ;;
    esac
  done
  PATH=$new
}
dedup_path
unset -f dedup_path
