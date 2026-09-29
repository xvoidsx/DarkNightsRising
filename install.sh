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
  sudo apt-get install -y mpg123 dialog libnotify-bin alsa-utils curl
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

install_voices() {
  # Download piper voice models (rhasspy/piper-voices on HuggingFace).
  # ~60MB each; skipped if already present.
  local voice_dir="$HOME/.local/share/dnr/voices"
  mkdir -p "$voice_dir"
  local base="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US"
  # model-name -> remote path fragment
  declare -A voices=(
    ["en_US-libritts_r-medium"]="libritts_r/medium/en_US-libritts_r-medium"
    ["en_US-ljspeech-medium"]="ljspeech/medium/en_US-ljspeech-medium"
    ["en_US-ryan-medium"]="ryan/medium/en_US-ryan-medium"
  )
  local name remote
  for name in "${!voices[@]}"; do
    remote="${voices[$name]}"
    if [ -f "$voice_dir/${name}.onnx" ]; then
      say "voice $name already downloaded"
      continue
    fi
    say "downloading voice $name..."
    curl -fsSL -o "$voice_dir/${name}.onnx" "$base/${remote}.onnx" || {
      say "warning: failed to download $name, voices will be silent"
      continue
    }
    curl -fsSL -o "$voice_dir/${name}.onnx.json" "$base/${remote}.onnx.json" 2>/dev/null || true
  done
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
  install_voices
  install_game
}

main
