#!/usr/bin/env bash
# Dark Nights Rising installer
# https://github.com/xvoidsx/DarkNightsRising
#
# Debian-centric for now (navi is Debian-based). Arch/Nix/Fedora flows
# will come later.
#
# Installs dependencies (piper-tts for voices, mpg123 for soundtrack)
# and makes the game globally playable as `darknightsrising`.
#
# Run: curl -fsSL https://raw.githubusercontent.com/xvoidsx/DarkNightsRising/main/install.sh | bash
##########################################
set -euo pipefail

say() { printf '  -> %s\n' "$*"; }

install_deps() {
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "This installer currently supports Debian/Ubuntu-based systems only." >&2
    echo "Arch/Nix/Fedora support is on the roadmap." >&2
    exit 1
  fi
  say "installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y mpg123 dialog libnotify-bin
  # piper-tts via pipx (stays current)
  if ! command -v pipx >/dev/null 2>&1; then
    sudo apt-get install -y pipx
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
