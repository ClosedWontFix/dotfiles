\
#!/usr/bin/env bash
# scripts/theme-bootstrap.sh
# -----------------------------------------------------------------------------
# Activate exactly ONE theme by linking themes/<name>.(toml|yaml|yml) to
# theme.d/active.toml. Searches multiple roots (priority order):
#   1) ~/.config/alacritty/themes
#   2) ~/.config/alacritty/alacritty-theme/themes
# If not found, points to themes/_empty.toml (tracked fallback).
# -----------------------------------------------------------------------------

set -euo pipefail
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/alacritty}"
THEME_DIRS=(
  "$CONFIG_DIR/themes"
  "$CONFIG_DIR/alacritty-theme/themes"
)
# THEMED_DIR="$CONFIG_DIR/theme.d"
ACTIVE="$CONFIG_DIR/theme.toml"
# ACTIVE="$THEMED_DIR/active.toml"
FALLBACK="$CONFIG_DIR/themes/_empty.toml"
# mkdir -p "$THEMED_DIR"

list() {
  echo "Available themes (union across roots):"
  {
    for d in "${THEME_DIRS[@]}"; do
      [[ -d "$d" ]] || continue
      shopt -s nullglob
      for f in "$d"/*.toml "$d"/*.yaml "$d"/*.yml; do
        bn="$(basename "$f")"; echo "${bn%.*}"
      done
      shopt -u nullglob
    done
  } | sort -u | sed 's/^/  - /'
}
[[ "${1:-}" == "--list" ]] && { list; exit 0; }

THEME="${1:-${ALACRITTY_THEME:-}}"
if [[ -z "$THEME" ]]; then
  echo "[theme-bootstrap] No theme specified. Use --list or pass a name."
  exit 0
fi

EX=(".toml" ".yaml" ".yml")
SRC=""
for d in "${THEME_DIRS[@]}"; do
  for e in "${EX[@]}"; do
    cand="$d/$THEME$e"
    [[ -f "$cand" ]] && { SRC="$cand"; break; }
  done
  [[ -n "$SRC" ]] && break
done

if [[ -n "$SRC" ]]; then
  ln -sfn "$SRC" "$ACTIVE"
  echo "[theme-bootstrap] theme.toml -> ${SRC#$CONFIG_DIR/}"
else
  ln -sfn "$FALLBACK" "$ACTIVE"
  echo "[theme-bootstrap] theme not found; theme.toml -> themes/_empty.toml (fallback)"
  echo "                  Use --list to see available themes."
fi
