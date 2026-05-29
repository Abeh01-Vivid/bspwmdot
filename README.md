# bspwm-dots

A minimal, keyboard-driven BSPWM setup styled after dwm — Catppuccin Mocha palette, kanji workspace labels, JetBrainsMono Nerd Font throughout, and a handwritten lemonbar that mirrors the classic dwm status bar layout.

---

## Contents

```
bspwmrc      — WM config (desktops, gaps, borders, window rules)
sxhkdrc      — Keybindings via sxhkd
bar.sh       — dwm-style lemonbar status bar
```

---

## Dependencies

| Package | Purpose |
|---|---|
| `bspwm` | Window manager |
| `sxhkd` | Hotkey daemon |
| `lemonbar` | Status bar renderer |
| `picom` | Compositor (shadows, transparency) |
| `rofi` | App launcher / window switcher |
| `alacritty` | Terminal |
| `xdotool` | Active window title for bar |
| `pamixer` | Volume control and query |
| `python3` | Layout symbol parsing in bar |
| `JetBrainsMono Nerd Font` | Font used everywhere |

On Arch/CachyOS:
```sh
paru -S bspwm sxhkd lemonbar-xft-git picom rofi alacritty xdotool pamixer ttf-jetbrains-mono-nerd
```

On Void:
```sh
sudo xbps-install bspwm sxhkd picom rofi alacritty xdotool pamixer
# lemonbar — build from source or use void-packages
```

On NixOS (flake), add to your `home.packages`:
```nix
pkgs.bspwm pkgs.sxhkd pkgs.lemonbar-xft pkgs.picom pkgs.rofi pkgs.alacritty
pkgs.xdotool pkgs.pamixer pkgs.nerd-fonts.jetbrains-mono
```

---

## Installation

```sh
# 1. Create config directories
mkdir -p ~/.config/bspwm ~/.config/sxhkd

# 2. Place files
cp bspwmrc  ~/.config/bspwm/bspwmrc
cp sxhkdrc  ~/.config/sxhkd/sxhkdrc
cp bar.sh   ~/.config/bspwm/bar.sh

# 3. Make executable
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/bar.sh
```

Then add `exec bspwm` to your `~/.xinitrc` or configure your display manager accordingly.

---

## Workspaces

Nine desktops labeled with kanji numerals — matching the dwm tag icons from the source `config.h`:

```
一  二  三  四  五  六  七  八  九
 1   2   3   4   5   6   7   8   9
```

Default window assignments:

| Desktop | App |
|---|---|
| 二 (2) | Firefox |
| 五 (5) | Gimp |

---

## Keybindings

MODKEY is `super`.

### Core

| Key | Action |
|---|---|
| `super + Return` | Open Alacritty |
| `super + p` | Rofi app launcher |
| `super + shift + p` | Rofi window switcher |
| `super + shift + c` | Close focused window |
| `super + ctrl + c` | Kill focused window (force) |
| `super + shift + q` | Quit bspwm |
| `super + ctrl + r` | Restart bspwm |

### Focus

| Key | Action |
|---|---|
| `super + j / k` | Focus next / previous window |
| `super + ←↓↑→` | Focus by direction |
| `super + 1–9` | Switch to desktop |
| `super + Tab` | Focus last desktop |

### Move & Swap

| Key | Action |
|---|---|
| `super + shift + ←↓↑→` | Swap window in direction |
| `super + shift + 1–9` | Send window to desktop |
| `super + ctrl + shift + 1–9` | Send and follow to desktop |
| `super + alt + ←↓↑→` | Move floating window |

### Resize & Layout

| Key | Action |
|---|---|
| `super + h / l` | Adjust split ratio (–/+ 0.05) |
| `super + alt + h/j/k/l` | Expand window edge |
| `super + alt + shift + h/j/k/l` | Contract window edge |
| `super + r` | Rotate tree 90° |
| `super + equal` | Balance / equalize splits |

### Window State

| Key | Action |
|---|---|
| `super + shift + space` | Toggle floating |
| `super + f` | Toggle fullscreen |
| `super + m` | Cycle desktop layout (tiled ↔ monocle) |
| `super + ctrl + space` | Toggle pseudo-tiled |
| `super + shift + s` | Toggle sticky |

### System

| Key | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume –5% |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp/Down` | Brightness ±5% |
| `Print` | Flameshot screenshot |
| `super + Escape` | Reload sxhkd config |

---

## Bar

`bar.sh` launches a lemonbar pinned to the **bottom** of the screen (matching `topbar = 0` from the source config).

```
[一][二][三]  []=  window title  ·····   CPU%  RAM  󰕾 vol%  Mon DD  HH:MM
└─ desktops ─┘ └─ layout ─┘ └── title ──┘        └──────────── status ────────┘
```

Desktop indicators use three states:

- **Focused** — mauve background `#cba6f7`, dark text
- **Occupied** — dimmed mauve text on surface background
- **Empty** — subdued grey text

The bar auto-starts from `bspwmrc` and refreshes every second. It requires `lemonbar` with XFT font support (the `-xft` variant in most distros).

---

## Colours

All colours are Catppuccin Mocha:

| Role | Hex | Swatch |
|---|---|---|
| Background | `#1e1e2e` | Base |
| Normal border | `#45475a` | Surface1 |
| Focused border | `#cba6f7` | Mauve |
| Urgent border | `#f38ba8` | Red |
| Presel feedback | `#89b4fa` | Blue |
| Bar accent | `#cba6f7` | Mauve |
| Bar text | `#cdd6f4` | Text |

---

## Customisation

**Change terminal** — edit `bar.sh` and `sxhkdrc`, replace `alacritty` with your preferred terminal.

**Change launcher** — edit `sxhkdrc`, replace the `rofi` commands with `dmenu_run` or any dmenu-compatible launcher.

**Wallpaper** — uncomment and update the `feh` line near the top of `bspwmrc`:
```sh
feh --bg-scale ~/.config/wallpapers/wall.jpg &
```

**Gaps** — adjust in `bspwmrc`:
```sh
bspc config window_gap   8   # inner gap
bspc config top_padding  8   # outer gap (bottom_padding accounts for bar height)
```

**Add a window rule**:
```sh
bspc rule -a "ClassName" desktop='^3' state=floating follow=on
```
Find the class name with `xprop | grep WM_CLASS`, then click the window.

---

## Credits

Inspired by the [dwm flexipatch](https://github.com/bakkeby/dwm-flexipatch) `config.h` and the general suckless/tiling aesthetic. Colour scheme is [Catppuccin Mocha](https://github.com/catppuccin/catppuccin).
