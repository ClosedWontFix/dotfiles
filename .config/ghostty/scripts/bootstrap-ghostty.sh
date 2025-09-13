#!/usr/bin/env bash
# bootstrap-ghostty.sh — create/refresh the Ghostty config symlink by OS

set -euo pipefail

# Detect platform (keep simple & explicit)
case "$(uname -s)" in
Linux*) PLATFORM="linux" ;;
Darwin*) PLATFORM="macos" ;;
*)
  echo "Unsupported OS: $(uname -s)" >&2
  exit 1
  ;;
esac

# Respect Ghostty's config dir per-OS
if [ "$PLATFORM" = "linux" ]; then
  CFG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
else
  CFG_DIR="$HOME/Library/Application Support/Ghostty"
fi

# Source repo/work-tree location for per-OS files (like your Alacritty themes)
SRC_DIR="$HOME/.config/ghostty"
SRC="$SRC_DIR/config.$PLATFORM"
DEST="$CFG_DIR/config"

# Safety checks
[ -f "$SRC" ] || {
  echo "Missing source config: $SRC" >&2
  exit 1
}

# Ensure target directory exists
mkdir -p "$CFG_DIR"

# Backup a pre-existing real file once (never touch if it's already a symlink)
if [ -f "$DEST" ] && [ ! -L "$DEST" ]; then
  cp -n "$DEST" "$DEST.bak.$(date +%Y%m%d%H%M%S)"
fi

# Create/update the symlink (the only mutable thing)
ln -snf "$SRC" "$DEST"

echo "Ghostty config linked:"
echo "  $DEST -> $SRC"
