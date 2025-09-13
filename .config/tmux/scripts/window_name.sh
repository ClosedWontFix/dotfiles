#!/usr/bin/env bash
# -*- bash -*-
# vim: ft=bash

cmd="$1"    # pane_current_command
pid="$2"    # pane PID
MAX_FILES=2 # maximum filenames to display

# Ensure we always return something
fallback_cmd="${cmd:-unknown}"

# Find the foreground process
real_pid=$(pgrep -P "$pid" | head -n1)
[[ -z "$real_pid" ]] && real_pid="$pid"

# Full command line
full_cmd=$(ps -p "$real_pid" -o args=)
[[ -z "$full_cmd" ]] && full_cmd="$fallback_cmd"

# --- SSH detection ---
if [[ "$cmd" == "ssh" || "$full_cmd" == ssh* ]]; then
  # Extract host argument (skip options like -p)
  host=$(echo "$full_cmd" | awk '{for(i=2;i<=NF;i++){if($i !~ /^-/){print $i; exit}}}')
  # Check ~/.ssh/config for alias
  if [ -f "$HOME/.ssh/config" ]; then
    alias_host=$(awk -v h="$host" '
          BEGIN{alias=""}
          $1=="Host" {alias=$2}
          $2==h {print alias; exit}
        ' "$HOME/.ssh/config")
    [ -n "$alias_host" ] && host="$alias_host"
  fi
  echo "ssh ${host%%.*}"

# --- Editors (show only first MAX_FILES basenames, add "…" if more) ---
elif [[ "$cmd" =~ ^(vi|vim|nvim)$ ]] || [[ "$full_cmd" =~ ^(vi|vim|nvim) ]]; then
  files=$(echo "$full_cmd" | awk '{for(i=2;i<=NF;i++){printf "%s ", $i}}' | sed 's/ $//')
  basenames=""
  count=0
  total_files=$(echo "$files" | wc -w)
  for f in $files; do
    basenames="$basenames $(basename "$f")"
    count=$((count + 1))
    [ "$count" -ge "$MAX_FILES" ] && break
  done
  [ "$total_files" -gt "$MAX_FILES" ] && basenames="$basenames …"
  echo "$cmd $basenames"

# --- Fallback to current command ---
else
  echo "$fallback_cmd"
fi
