#!/usr/bin/env bash
# Dark Nights Rising installer
# https://github.com/xvoidsx/DarkNightsRising
#
# Installs dependencies (piper-tts for voices, mpg123 for soundtrack)
# and makes the game globally playable as `darknightsrising`.
#
# Run: curl -fsSL https://raw.githubusercontent.com/xvoidsx/DarkNightsRising/main/install.sh | bash
##########################################
set -euo pipefail

say() { printf '  -> %s\n' "$*"; }

install_deps() {
  say "installing dependencies..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y mpg123 dialog libnotify-bin
    # piper-tts via pipx (stays current)
    if ! command -v pipx >/dev/null 2>&1; then
      sudo apt-get install -y pipx
    fi
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y mpg123 dialog libnotify
    if ! command -v pipx >/dev/null 2>&1; then
      sudo dnf install -y pipx
    fi
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm mpg123 dialog libnotify
    if ! command -v pipx >/dev/null 2>&1; then
      sudo pacman -Sy --noconfirm python-pipx
    fi
  fi

  if ! command -v piper >/dev/null 2>&1; then
    say "installing piper-tts via pipx..."
    pipx install piper-tts
    pipx ensurepath 2>/dev/null || true
  else
    say "piper-tts already installed"
  fi
}

install_game() {
  local dest="/usr/local/bin/darknightsrising"
  local src="https://raw.githubusercontent.com/xvoidsx/DarkNightsRising/main/darknightsrising.sh"
  say "installing game launcher to $dest..."
  sudo curl -fsSL "$src" -o "$dest"
  sudo chmod 0755 "$dest"
  say "done — run: darknightsrising"
}

main() {
  echo "= = = = = Dark Nights Rising installer = = = = ="
  install_deps
  install_game
}

main
