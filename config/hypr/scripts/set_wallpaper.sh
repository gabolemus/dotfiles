#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Config ---
wallpaperdir="$HOME/Pictures/Wallpapers"
hyprpaper_conf="$HOME/.config/hypr/hyprpaper.conf"

# Monitors to apply the same wallpaper to
monitors=( "eDP-2" "DP-3" "DP-4" "DP-8" "DP-9" "DP-10" )
fit_mode="cover"
# --- End config ---

get_current_wallpaper() {
  # Reads the first `path = ...` from the current hyprpaper.conf (if it exists).
  # Returns empty string if not found.
  [[ -f "$hyprpaper_conf" ]] || return 0
  awk -F' = ' '/^[[:space:]]*path[[:space:]]*=/ {print $2; exit}' "$hyprpaper_conf" || true
}

pick_new_wallpaper() {
  local current="$1"
  local -a files=()

  # Gather candidates safely (supports spaces/newlines in filenames)
  mapfile -d '' files < <(
    find "$wallpaperdir" -type f \( -iname '*.jpg' -o -iname '*.png' \) -print0
  )

  if (( ${#files[@]} == 0 )); then
    echo "Error: No wallpapers found in '$wallpaperdir'." >&2
    exit 1
  fi

  # Filter out the current wallpaper if possible
  if [[ -n "$current" ]]; then
    local -a filtered=()
    local f
    for f in "${files[@]}"; do
      [[ "$f" == "$current" ]] && continue
      filtered+=( "$f" )
    done

    # If filtering removed everything (only one wallpaper), fall back to original list
    if (( ${#filtered[@]} > 0 )); then
      files=( "${filtered[@]}" )
    fi
  fi

  # Pick a random element
  local idx=$(( RANDOM % ${#files[@]} ))
  printf '%s' "${files[$idx]}"
}

write_wallpaper_block() {
  # Usage: write_wallpaper_block <monitor_name> <wallpaper_path> [fit_mode]
  local monitor="$1"
  local path="$2"
  local mode="${3:-cover}"

  cat <<EOF
wallpaper {
  monitor = $monitor
  path = $path
  fit_mode = $mode
}

EOF
}

# --- Choose wallpaper (different from current if possible) ---
current_wallpaper="$(get_current_wallpaper)"
rand_wallpaper="$(pick_new_wallpaper "$current_wallpaper")"

# Extract wallpaper number (expects format: wallpaper-N.jpg)
wallpaper_filename="$(basename "$rand_wallpaper")"
wallpaper_num="$(rg -oP 'wallpaper-\K[0-9]+' <<<"$wallpaper_filename" || true)"

# --- Write hyprpaper.conf atomically ---
tmp_conf="$(mktemp)"
{
  printf 'splash = false\n\n'
  for m in "${monitors[@]}"; do
    write_wallpaper_block "$m" "$rand_wallpaper" "$fit_mode"
  done
} >"$tmp_conf"
mv -f "$tmp_conf" "$hyprpaper_conf"

# --- Color mappings (unchanged) ---
declare -A active_colors
declare -A inactive_colors

active_colors["1"]="rgba(4ed5d3ee) rgba(074a77ee) 45deg"
inactive_colors["1"]="rgba(595959aa)"

active_colors["2"]="rgba(ffcaabee) rgba(d86373ee) 45deg"
inactive_colors["2"]="rgba(595959aa)"

active_colors["3"]="rgba(58b1e0ee) rgba(ffe3e7ee) 45deg"
inactive_colors["3"]="rgba(595959aa)"

active_colors["4"]="rgba(f79345ee) rgba(85556fee) 45deg"
inactive_colors["4"]="rgba(595959aa)"

active_colors["5"]="rgba(72cce8ee) rgba(81476Dee) 45deg"
inactive_colors["5"]="rgba(595959aa)"

borders_conf="$HOME/.config/hypr/conf/borders.conf"

if [[ -n "${wallpaper_num:-}" && -n "${active_colors[$wallpaper_num]:-}" ]]; then
  sed -i -E \
    -e "/^\s*col\.active_border\s*=.*/s|=.*|= ${active_colors[$wallpaper_num]}|" \
    -e "/^\s*col\.inactive_border\s*=.*/s|=.*|= ${inactive_colors[$wallpaper_num]}|" \
    "$borders_conf"
else
  echo "Warning: No color scheme defined (or no number found) for wallpaper '$wallpaper_filename'" >&2
fi

# Restart hyprpaper
pkill -x hyprpaper || true
hyprpaper & disown

# Reload Hyprland config to apply border changes
hyprctl reload
