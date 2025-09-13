#!/usr/bin/env bash
# scripts/bootstrap.sh
# -----------------------------------------------------------------------------
# Combined bootstrap for macOS & Linux.
# - Sets os.toml -> macos.toml OR linux.toml (symlink)
# - Sets host.d/active.toml -> hosts/<hostname>.toml OR hosts/_empty.toml (symlink)
# Pointers are NOT tracked in git.
# -----------------------------------------------------------------------------

set -euo pipefail
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/alacritty}"
HOSTS_DIR="$CONFIG_DIR/hosts"
# HOSTD_DIR="$CONFIG_DIR/host.d"

mkdir -p "$HOSTS_DIR"
# mkdir -p "$HOSTS_DIR" "$HOSTD_DIR"

# OS pointer
if command -v sw_vers >/dev/null 2>&1 || [[ "${OSTYPE:-}" == darwin* ]]; then
  ln -sfn "$CONFIG_DIR/macos.toml" "$CONFIG_DIR/os.toml"
  echo "[bootstrap] os.toml -> macos.toml"
else
  ln -sfn "$CONFIG_DIR/linux.toml" "$CONFIG_DIR/os.toml"
  echo "[bootstrap] os.toml -> linux.toml"
fi

# Host pointer
HN="$(hostname -s 2>/dev/null || hostname)"
TARGET="$HOSTS_DIR/$HN.toml"
FALLBACK="$HOSTS_DIR/_empty.toml"
if [[ -f "$TARGET" ]]; then
  ln -sfn "$TARGET" "$CONFIG_DIR/host.toml"
  echo "[bootstrap] host.toml -> hosts/$HN.toml"
  # ln -sfn "$TARGET" "$HOSTD_DIR/active.toml"
  # echo "[bootstrap] host.d/active.toml -> hosts/$HN.toml"
else
  ln -sfn "$FALLBACK" "$CONFIG_DIR/host.toml"
  echo "[bootstrap] host.toml -> hosts/_empty.toml (fallback)"
  # ln -sfn "$FALLBACK" "$HOSTD_DIR/active.toml"
  # echo "[bootstrap] host.d/active.toml -> hosts/_empty.toml (fallback)"
fi
