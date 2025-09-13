# -*- zsh -*-
# vim: ft=zsh
#
# File: ~/.zshrc
# Author: ClosedWontFix
#

# Load only in interactive shells (skip for non-interactive)
[[ -o interactive ]] || return

# Ensure any interactive 'sh' launched from here will also load ~/.shrc
[[ -z "${ENV:-}" ]] && ENV="$HOME/.shrc"; export ENV

# Source shared shell configuration
[[ -r "$HOME/.shrc" ]] && source "$HOME/.shrc"

# Ensure we're in zsh semantics
emulate -L zsh

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INTERACTIVE_COMMENTS
setopt SHARE_HISTORY
export HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
export HISTSIZE="${HISTSIZE:-50000}"
export SAVEHIST="${SAVEHIST:-20000}"

# Output full history
alias history='history 0'

#setopt interactivecomments

# Enabled autocomplete
autoload -Uz +X compinit && compinit

# Make completion case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable vi-mode
bindkey -v

# unbind ^t on macos; it does some kind of SIGINFO dump?
[[ "$MACOS" == 1 ]] && bindkey -r '^t'

# allow vv to edit the command line
#autoload -Uz edit-command-line
#zle -N edit-command-line
#bindkey -M vicmd 'vv' edit-command-line

# allow ctrl-p, ctrl-n for navigate history
#bindkey '^P' up-history
#bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion
#bindkey '^?' backward-delete-char
#bindkey '^h' backward-delete-char
#bindkey '^w' backward-kill-word

# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Right prompt spacing fix
typeset -g ZLE_RPROMPT_INDENT=0

# Completion cache
: "${XDG_CACHE_HOME:=$HOME/.cache}"
autoload -Uz compinit
mkdir -p "${XDG_CACHE_HOME}/zsh" 2>/dev/null || true
compinit -d "${XDG_CACHE_HOME}/zsh/.zcompdump"

# Optional fzf
if command -v fzf >/dev/null 2>&1; then
  [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
  [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
  if command -v brew >/dev/null 2>&1; then
    [[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
    [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  fi
fi

# Prompt block (Starship first; fallback to git-prompt + kube-ps1)
setopt PROMPT_SUBST

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Try to load git-prompt from common locations
  typeset -g __GITPROMPT_LOADED=0
  for _gp in \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/share/git/git-prompt.sh \
    "${$(command -v brew 2>/dev/null && brew --prefix)/etc/bash_completion.d/git-prompt.sh}"
  do
    [[ -n "$_gp" && -r "$_gp" ]] || continue
    source "$_gp" || true
    if typeset -f __git_ps1 >/dev/null; then
      __GITPROMPT_LOADED=1
      break
    fi
  done

  # Configure git-prompt (if loaded)
  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export GIT_PS1_SHOWUPSTREAM="auto"

  # kube-ps1 from brew or system
  KUBE_PS1_SH=""
  if command -v brew >/dev/null 2>&1 && [[ -r "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh" ]]; then
    KUBE_PS1_SH="$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
  elif [[ -r /usr/share/kube-ps1/kube-ps1.sh ]]; then
    KUBE_PS1_SH=/usr/share/kube-ps1/kube-ps1.sh
  elif [[ -r /usr/share/kube-ps1.sh ]]; then
    KUBE_PS1_SH=/usr/share/kube-ps1.sh
  fi
  if [[ -n "$KUBE_PS1_SH" ]]; then
    source "$KUBE_PS1_SH" || true
  fi

  autoload -Uz colors && colors

  PROMPT='%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}'
  [[ -n "$KUBE_PS1_SH" ]] && PROMPT="${PROMPT} $(kube_ps1)"
  if typeset -f __git_ps1 >/dev/null; then
    PROMPT="${PROMPT}"'$(__git_ps1 " (git:%s)")'
  fi
  PROMPT="${PROMPT} %#"
fi

# Machine-local overrides (per-host)
# Cache short hostname once (fallback to full hostname if -s unsupported)
if command -v hostname >/dev/null 2>&1; then
  : ${HOST_SHORT:=$(hostname -s 2>/dev/null || hostname 2>/dev/null)}
fi

# shellcheck source=/dev/null
[[ -n "$HOST_SHORT" && -r "$HOME/.zshrc.$HOST_SHORT" ]] && source "$HOME/.zshrc.$HOST_SHORT"

