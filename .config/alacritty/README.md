# Alacritty: Git-Friendly OS/Host + Theme Pointers

This package is designed for dotfiles repos where **per-machine pointers** should
NOT be tracked. We use single-file imports and bootstrap scripts to point those
files at tracked targets.

## Imports (single-file pointers)
```toml
[general]
import = [
  "~/.config/alacritty/base.toml",
  "~/.config/alacritty/os.toml",
  "~/.config/alacritty/host.d/active.toml",
  "~/.config/alacritty/theme.d/active.toml"
]
```

- `host.d/active.toml` → symlink/copy to `hosts/<hostname>.toml` or `hosts/_empty.toml`
- `theme.d/active.toml` → symlink/copy to `themes/<name>.(toml|yaml|yml)` or `themes/_empty.toml`

## Track these
- `hosts/` — all your host profiles **plus** `_empty.toml`
- `themes/` — all your themes **plus** `_empty.toml`
- `alacritty.toml`, `base.toml`, `macos.toml`, `linux.toml`, `windows.toml`
- `scripts/` — bootstraps

## Ignore these (per-machine)
Add to your dotfiles `.gitignore`:
```
os.toml
host.toml
host.d/active.toml
theme.toml
theme.d/active.toml
```

## Bootstraps

### macOS / Linux
```bash
~/.config/alacritty/scripts/bootstrap.sh                # sets os + host pointer
~/.config/alacritty/scripts/theme-bootstrap.sh --list   # list themes across roots
~/.config/alacritty/scripts/theme-bootstrap.sh dracula  # sets theme pointer
```

### Windows
PowerShell:
```powershell
& "$env:APPDATAlacritty\scripts\windows-bootstrap-all.ps1"
& "$env:APPDATAlacritty\scripts\windows-theme-bootstrap.ps1" -List
& "$env:APPDATAlacritty\scripts\windows-theme-bootstrap.ps1" -Theme dracula
```
cmd.exe:
```bat
scripts\windows-bootstrap-all.bat
scripts\windows-theme-bootstrap.bat --list
scripts\windows-theme-bootstrap.bat dracula
```

## Notes
- If a host/theme isn’t found, the bootstrap points to the tracked `_empty.toml`.
- Start Alacritty with `alacritty -vv` to confirm it imports the two `active.toml` files.
