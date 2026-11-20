#!/bin/sh
# Terminal setup: links home/ into $HOME and installs the tools with mise.
#
# Idempotent: run it again after a pull. VS Code's dotfiles feature runs it in
# every new devcontainer. On a workstation (Debian/Ubuntu, native or WSL) it
# also apt-installs fish and tmux; it never changes the login shell (set fish
# as the terminal's profile command instead).
set -eu

DOT=$(cd "$(dirname "$0")" && pwd)
BIN="$HOME/.local/bin"
export PATH="$BIN:$PATH" MISE_YES=1

say() { printf '\033[1;35m==>\033[0m %s\n' "$*"; }

if [ -f /.dockerenv ] || [ -f /run/.containerenv ] || [ -n "${REMOTE_CONTAINERS:-}" ] || [ -n "${CODESPACES:-}" ]; then
    ENV=container
elif [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qi microsoft /proc/version 2>/dev/null; then
    ENV=wsl
else
    ENV=native
fi
say "environment: $ENV"

# ---- system packages (workstation only: the devcontainer image ships them, and has no sudo)
if [ "$ENV" != container ]; then
    missing=
    for pkg in fish tmux; do
        command -v "$pkg" >/dev/null 2>&1 || missing="$missing $pkg"
    done
    if [ -n "$missing" ]; then
        say "apt install:$missing"
        sudo apt-get update -qq
        # shellcheck disable=SC2086
        sudo apt-get install -y $missing
    fi
fi

# ---- drop links into this repo left by an older layout (e.g. stow's
#      ~/.config/fish -> repo) or pointing to files since removed from home/
{ find "$HOME" -maxdepth 1 -type l; find "$HOME/.config" "$HOME/.ssh" -maxdepth 3 -type l 2>/dev/null; } |
while IFS= read -r link; do
    target=$(readlink -m "$link")
    case "$target" in
        "$DOT"/home/*) [ -e "$link" ] || { rm "$link"; say "removed stale link $link"; } ;;
        "$DOT"/*) rm "$link"; say "removed old link $link" ;;
    esac
done

# ---- link every file of home/ into $HOME (files, never whole directories, so
#      tool-written files like fish_variables stay out of the repo)
say "linking configs"
(cd "$DOT/home" && find . -type f) | while IFS= read -r f; do
    f=${f#./}
    dst="$HOME/$f"
    mkdir -p "$(dirname "$dst")"
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "$dst.bak"
        say "kept your old $dst as $dst.bak"
    fi
    ln -sfn "$DOT/home/$f" "$dst"
done

# ---- tools: mise (already in the devcontainer image) + ~/.config/mise/config.toml
mkdir -p "$BIN"
if ! command -v mise >/dev/null 2>&1; then
    say "installing mise"
    curl -fsSL https://mise.run | sh
fi
say "installing tools"
mise install
mise exec -- bat cache --build >/dev/null

# ---- Catppuccin plugins for tmux and neovim, pinned (no plugin managers)
clone() { # <github repo> <tag> <dir>
    if [ "$(git -C "$3" describe --tags --exact-match 2>/dev/null)" != "$2" ]; then
        rm -rf "$3"
        git clone -q --depth 1 -b "$2" "https://github.com/$1" "$3" 2>/dev/null
        say "$1 $2"
    fi
}
clone catppuccin/tmux v2.3.2 "$HOME/.config/tmux/plugins/catppuccin/tmux"
clone catppuccin/nvim v2.0.0 "$HOME/.local/share/nvim/site/pack/themes/start/catppuccin"

# ---- WSL: bridge to the Windows ssh-agent (see conf.d/50-ssh-agent.fish)
if [ "$ENV" = wsl ] && [ ! -x "$BIN/wsl2-ssh-agent" ]; then
    say "installing wsl2-ssh-agent"
    curl -fsSL -o "$BIN/wsl2-ssh-agent" \
        https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
    chmod 755 "$BIN/wsl2-ssh-agent"
fi

say "done — open a new fish"
