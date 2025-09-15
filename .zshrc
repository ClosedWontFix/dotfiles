# -*- zsh -*-
# vim: ft=zsh
#
# File: ~/.zshrc
# Author: Dan Borkowski
#

# Load only in interactive shells (skip for non-interactive)
[[ -o interactive ]] || return

# Ensure any interactive 'sh' launched from here will also load ~/.shrc
[[ -z "${ENV:-}" ]] && ENV="$HOME/.shrc"; export ENV

# Source shared shell configuration
[[ -r "$HOME/.shrc" ]] && source "$HOME/.shrc"

##### Completion & ZLE #########################################################

# Enable completion (cached in XDG cache)
: "${XDG_CACHE_HOME:=$HOME/.cache}"
mkdir -p "${XDG_CACHE_HOME}/zsh" 2>/dev/null || true
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME}/zsh/.zcompdump-${ZSH_VERSION}"

# Smarter, case-insensitive matching (case-insensitive; then dash/underscore/period flex; then substring)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Show nice descriptions and group results
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{yellow}– %d –%f'
zstyle ':completion:*' group-name ''

# Complete menu selection with arrow keys
zmodload -i zsh/complist
zstyle ':completion:*' menu select
bindkey -M menuselect '^M' accept-line
bindkey -M menuselect '^G' send-break
bindkey -M menuselect '^N' down-line-or-history
bindkey -M menuselect '^P' up-line-or-history
bindkey -M menuselect '^F' forward-char
bindkey -M menuselect '^B' backward-char

# Don’t beep on failed completion
setopt NO_BEEP

# Enable vi mode (and make sure keys apply in both insert/command maps)
bindkey -v
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M vicmd '^A' beginning-of-line
bindkey -M vicmd '^E' end-of-line

# History search (Ctrl-R/Ctrl-S). Ensure Ctrl-S works by disabling XOFF.
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward
stty -ixon 2>/dev/null

# Unbind Ctrl-T on macOS (it triggers SIGINFO there)
#[[ "$MACOS" = 1 ]] && bindkey -r '^t'

# Right prompt spacing fix
typeset -g ZLE_RPROMPT_INDENT=0

# Output full history
alias history='history 0'

# Optional fzf
# if command -v fzf >/dev/null 2>&1; then
#   [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
#   [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
#   if command -v brew >/dev/null 2>&1; then
#     [[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
#     [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
#   fi
# fi

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

# --- History configuration ---

# Where and how much to save
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
typeset -gi HISTSIZE=100000
typeset -gi SAVEHIST=100000

# Write + share history immediately
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY

# Include timestamps + duration in history file
setopt EXTENDED_HISTORY

# De-dupe & cleanup behavior
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS        # (optional) only skip if previous line was identical
# setopt HIST_IGNORE_ALL_DUPS    # (optional) skip all duplicates entirely
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Misc
setopt INTERACTIVE_COMMENTS
setopt HIST_FCNTL_LOCK
# setopt HIST_SAVE_BY_COPY       # enable if your FS prefers copy+rename semantics

