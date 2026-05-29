#!/bin/sh
# ╔══════════════════════════════════════════════════════════════╗
# ║  bar.sh — dwm-style lemonbar for BSPWM / Abe               ║
# ║  Layout: [desktops] [layout] [title]  ........  [status]   ║
# ║  Font: JetBrainsMono Nerd Font  |  Theme: Catppuccin Mocha ║
# ╚══════════════════════════════════════════════════════════════╝

# ── Catppuccin Mocha palette ─────────────────────────────────────────────────
BASE="#1e1e2e"
MANTLE="#181825"
SURFACE0="#313244"
SURFACE1="#45475a"
TEXT="#cdd6f4"
SUBTEXT0="#a6adc8"
LAVENDER="#b4befe"
MAUVE="#cba6f7"     # accent / selected
BLUE="#89b4fa"
SAPPHIRE="#74c7ec"
GREEN="#a6e3a1"
YELLOW="#f9e2af"
PEACH="#fab387"
RED="#f38ba8"

# ── Config ────────────────────────────────────────────────────────────────────
FONT="JetBrainsMono Nerd Font:size=11"
ICON_FONT="JetBrainsMono Nerd Font:size=13"
BAR_H=28
SCREEN_W=$(xdpyinfo | awk '/dimensions/{print $2}' | cut -dx -f1)

# Kanji workspace labels (mirrors your dwm tagicons)
LABELS="一 二 三 四 五 六 七 八 九"

# ── Helpers ───────────────────────────────────────────────────────────────────
fg()  { printf "%%{F%s}" "$1"; }
bg()  { printf "%%{B%s}" "$1"; }
rst() { printf "%%{F-}%%{B-}"; }
bold(){ printf "%%{T2}%s%%{T1}" "$1"; }  # lemonbar font index

# Powerline separator (right-pointing solid triangle  )
PL_RIGHT=""
PL_LEFT=""

# ── Modules ───────────────────────────────────────────────────────────────────

desktops() {
    local out=""
    local i=1
    for label in $LABELS; do
        local state
        state=$(bspc query -D --desktop "^${i}" -d .focused 2>/dev/null)
        local occupied
        occupied=$(bspc query -N -d "^${i}" 2>/dev/null)

        if [ -n "$state" ]; then
            # Focused desktop
            out="${out}$(fg "$BASE")$(bg "$MAUVE") ${label} $(rst)"
        elif [ -n "$occupied" ]; then
            # Occupied but unfocused
            out="${out}$(fg "$MAUVE")$(bg "$SURFACE0") ${label} $(rst)"
        else
            # Empty
            out="${out}$(fg "$SUBTEXT0")$(bg "$BASE") ${label} $(rst)"
        fi
        i=$((i + 1))
    done
    printf "%s" "$out"
}

layout_symbol() {
    # bspwm doesn't have named layouts like dwm, so we show the desktop layout
    local layout
    layout=$(bspc query -T -d | python3 -c "
import sys,json
try:
    d=json.load(sys.stdin)
    l=d.get('layout','tiled')
    print({'tiled':'[]=','monocle':'[M]','floating':'><>'}.get(l,'[]='))
except:
    print('[]=')
" 2>/dev/null || echo "[]=")
    printf "$(fg "$BASE")$(bg "$BLUE") %s $(rst)" "$layout"
}

win_title() {
    local title
    title=$(xdotool getactivewindow getwindowname 2>/dev/null | cut -c1-60)
    [ -z "$title" ] && title="bspwm"
    printf "$(fg "$TEXT")$(bg "$SURFACE0") %s $(rst)" "$title"
}

clock() {
    printf "$(fg "$BASE")$(bg "$MAUVE")  %s $(rst)" "$(date '+%H:%M')"
}

date_mod() {
    printf "$(fg "$BASE")$(bg "$BLUE")  %s $(rst)" "$(date '+%a %d %b')"
}

volume() {
    local vol muted icon
    vol=$(pamixer --get-volume 2>/dev/null || echo "??")
    muted=$(pamixer --get-mute 2>/dev/null || echo "false")
    if [ "$muted" = "true" ]; then
        icon="󰝟"
        printf "$(fg "$RED")$(bg "$SURFACE0") %s %s%% $(rst)" "$icon" "$vol"
    else
        icon="󰕾"
        printf "$(fg "$TEXT")$(bg "$SURFACE0") %s %s%% $(rst)" "$icon" "$vol"
    fi
}

cpu_usage() {
    local cpu
    cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}' 2>/dev/null || echo "??")
    printf "$(fg "$TEXT")$(bg "$SURFACE0")  %s%% $(rst)" "$cpu"
}

mem_usage() {
    local mem
    mem=$(free -m | awk '/Mem:/{printf "%dM", $3}')
    printf "$(fg "$TEXT")$(bg "$SURFACE0")  %s $(rst)" "$mem"
}

# ── Main bar loop ─────────────────────────────────────────────────────────────
bar_content() {
    while true; do
        LEFT="$(desktops) $(layout_symbol) $(win_title)"
        RIGHT="$(cpu_usage) $(mem_usage) $(volume) $(date_mod) $(clock)"

        printf "%%{l}%s%%{r}%s\n" "$LEFT" "$RIGHT"
        sleep 1
    done
}

# Kill existing instance
pkill -x lemonbar 2>/dev/null
sleep 0.1

# Launch lemonbar pinned to the bottom
bar_content | lemonbar \
    -g "${SCREEN_W}x${BAR_H}+0-0" \
    -f "$FONT" \
    -F "$TEXT" \
    -B "$BASE" \
    -p \
    | sh &

wait
