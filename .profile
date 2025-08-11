# File: ~/.profile
# Author: ClosedWontFix
# Last update: 8/10/2025

if [ "$(uname)" = "Linux" ] && [ "$(id -u)" != "0" ]; then

  # Reload v4l2loopback module
  reload_v42loopback() {
    sudo modprobe -r v4l2loopback
    sudo modprobe v4l2loopback
  }

  # Mouse jiggler
  if [ "$(which xdotool)" ]; then
    jiggler() {
      while true; do
        xdotool mousemove_relative -- 1 1
        sleep 1
        xdotool mousemove_relative -- -1 -1
        sleep 60
      done
    }
  fi

  # Magic 8-ball
  8ball() {
    echo
    echo "Shaking ..."
    echo
    sleep 2
    value="$( (awk 'BEGIN { srand(); print int(rand() % 3) }') )"
    case $value in
      0) echo "All signs point to yes." ;;
      1) echo "The answer is no." ;;
      2) echo "Ask again later." ;;
      3) echo "Outlook hazy." ;;
    esac
    echo
  }

fi


if [ -x /usr/bin/dircolors ]; then
  if [ -r "${HOME}"/.dircolors ]; then
    eval "$(dircolors -b "${HOME}"/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi

elif [ "$(uname)" = "Darwin" ]; then
  CLICOLOR=1
  LSCOLORS='ExFxCxDxBxegedabagacad'
  export CLICOLOR LSCOLORS

fi


if [ "$(id -u)" = "0" ]; then
  alias ls='ls --color=auto'
  alias la='ls -la --color=auto'
  alias ll='ls -l --color=auto'

else
  # Print human-readable sizes
  alias ls='ls -h --color=auto'
  alias la='ls -lah --color=auto'
  alias ll='ls -lh --color=auto'

fi


alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

alias dt='date +%Y%m%d-%H%M%S'


if [ "$(which dnf)" ]; then
  alias dnf='sudo dnf'
  alias yum='sudo dnf'

elif [ "$(which yum)" ]; then
  alias yum='sudo yum'

fi


# Alias vi (nvim > vim > vi)
if [ "$(which nvim)" ]; then
  alias vi='nvim'
  EDITOR='nvim'
  export EDITOR

  if [ "$(id -u)" != "0" ]; then
    [ -d "${HOME}"/.config/nvim ] || mkdir -p "${HOME}"/.config/nvim

    if ! [ "$(grep 'require("config.lazy")' "${HOME}"/.config/nvim/init.lua)" ]; then
      echo
      echo "Neovim is installed, but not configured to use LazyVim."
      echo
      echo "Backing up previous Neovim configuration (if applicable)..."
      [ -d "${HOME}"/.config/nvim ] && mv "${HOME}"/.config/nvim "${HOME}"/.config/nvim."$(date +%Y%m%d-%H%M%S)"
      [ -d "${HOME}"/.local/share/nvim ] && mv "${HOME}"/.local/share/nvim "${HOME}"/local/share/nvim."$(date +%Y%m%d-%H%M%S)"
      [ -d "${HOME}"/.local/state/nvim ] && mv "${HOME}"/.local/state/nvim "${HOME}"/.local/state/nvim."$(date +%Y%m%d-%H%M%S)"
      [ -d "${HOME}"/.cache/nvim ] && mv "${HOME}"/.cache/nvim "${HOME}"/.cache/nvim."$(date +%Y%m%d-%H%M%S)"
      echo
      echo "Installing LazyVim..."
      echo
      git clone -q https://github.com/LazyVim/starter "${HOME}"/.config/nvim
      rm -rf "${HOME}"/.config/nvim/.git
      echo

    fi

  fi

elif [ "$(which vim)" ]; then
  alias vi='vim'
  EDITOR='vim'
  export EDITOR

elif [ "$(which vi)" ]; then
  EDITOR='vi'
  export EDITOR

fi


if [ "$(which less)" ]; then

  if ! [ "$(readlink /bin/sh)" = "busybox" ]; then
    PAGER='less -R'
    # Enable mouse scrolling in less
    LESS='--mouse'
    export PAGER LESS

  fi

  if [ "$(echo "$LANG" | grep  UTF-8)" ]; then 
    LESSCHARSET='UTF-8'
    export LESSCHARSET

  fi

fi


if [ "$(which git)" ] && [ "$(id -u)" != "0" ]; then

  if [ -z "${ZSH+x}" ]; then
    # Define git aliases if $ZSH is not defined
    # These aliases _might_ be borrowed from oh-my-zsh
    alias g=git
    alias ga='git add'
    alias gaa='git add --all'
    alias gb='git branch'
    alias gba='git branch --all'
    alias gbd='git branch --delete'
    alias gbD='git branch --delete --force'
    alias gbm='git branch --move'
    alias gbnm='git branch --no-merged'
    alias gbr='git branch --remote'
    alias gco='git checkout'
    alias gcB='git checkout -B'
    alias gcb='git checkout -b'
    alias gcmsg='git commit --message'
    alias gc='git commit --verbose'
    alias gca='git commit --verbose --all'
    alias 'gca!'='git commit --verbose --all --amend'
    alias 'gc!'='git commit --verbose --amend'
    alias gcf='git config --list'
    alias gd='git diff'
    alias gdca='git diff --cached'
    alias gdcw='git diff --cached --word-diff'
    alias gds='git diff --staged'
    alias gdw='git diff --word-diff'
    alias gdup='git diff @{upstream}'
    alias gdt='git diff-tree --no-commit-id --name-only -r'
    alias gf='git fetch'
    alias gfo='git fetch origin'
    alias glgg='git log --graph'
    alias glgga='git log --graph --decorate --all'
    alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
    alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
    alias glo='git log --oneline --decorate'
    alias glog='git log --oneline --decorate --graph'
    alias gloga='git log --oneline --decorate --graph --all'
    alias gfg='git ls-files | grep'
    alias gl='git pull'
    alias gpr='git pull --rebase'
    alias gprv='git pull --rebase -v'
    alias gp='git push'
    alias gpd='git push --dry-run'
    alias gpv='git push --verbose'
    alias gpu='git push upstream'
    alias gr='git remote'
    alias grv='git remote --verbose'
    alias gra='git remote add'
    alias grrm='git remote remove'
    alias grmv='git remote rename'
    alias grset='git remote set-url'
    alias grup='git remote update'
    alias grh='git reset'
    alias grhh='git reset --hard'
    alias grm='git rm'
    alias grmc='git rm --cached'

  fi

  alias dotfiles='git --git-dir="${HOME}"/.dotfiles/ --work-tree="${HOME}"'

fi


if [ "$(which htop)" ] && [ "$(id -u)" != "0" ]; then
  alias top='htop'

fi


# Alias codium for VSCode compatibility
if [ "$(which codium)" ]; then
  alias code='codium'

fi


# Disable pager for systemd
if [ -e /run/systemd/system ]; then
  SYSTEMD_PAGER=''
  export SYSTEMD_PAGER

fi


if [ -f /usr/bin/gpg ]; then
  GPG_TTY="$(tty)"
  export GPG_TTY
fi


# Activate Homebrew
if [ -z "${HOMEBREW_PREFIX+x}" ]; then

  if [ "$(uname)" = "Darwin" ]; then

    if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"

    elif [ -f /usr/local/bin/brew ]; then
      eval "$(/usr/local/bin/brew shellenv)"

    fi

  elif [ "$(uname)" = "Linux" ] && [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  fi

fi


if [ -n "${HOMEBREW_PREFIX+x}" ]; then

  if [ -d "${HOMEBREW_PREFIX}/opt/curl/bin" ]; then
    PATH="${HOMEBREW_PREFIX}/opt/curl/bin:${PATH}"
    export PATH

  fi

  if [ -d "${HOMEBREW_PREFIX}"/opt/findutils/libexec/gnubin ]; then
    alias find='"${HOMEBREW_PREFIX}"/bin/gfind'
    alias locate='"${HOMEBREW_PREFIX}"/bin/glocate'
    alias updatedb='"${HOMEBREW_PREFIX}"/bin/gupdatedb'
    alias xargs='"${HOMEBREW_PREFIX}"bin/gxargs'

  fi

  if [ -d "${HOMEBREW_PREFIX}"/opt/e2fsprogs ]; then
    PATH="${HOMEBREW_PREFIX}/opt/e2fsprogs/bin:${HOMEBREW_PREFIX}/opt/e2fsprogs/sbin:${PATH}"
    export PATH

  fi

fi


# Include work specific aliases
[ -f "${HOME}"/.aliases.work ] && . "${HOME}"/.aliases.work

# User specific environment
[ -d "${HOME}"/.local/bin ] || mkdir "${HOME}"/.local/bin
[ -d "${HOME}"/bin ] || mkdir "${HOME}"/bin
if ! [ "$(echo "${PATH}" | grep "${HOME}"/.local/bin:"${HOME}"/bin:)" ]; then
  PATH="${HOME}/.local/bin:${HOME}/bin:${PATH}"
  export PATH

fi
