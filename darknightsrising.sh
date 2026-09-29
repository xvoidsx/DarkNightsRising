#!/usr/bin/env bash
# darknightsrising.sh — launcher
# Clones (or updates) Dark Nights Rising and starts the game.
set -euo pipefail

GAME_DIR="$HOME/.local/share/darknightsrising"
REPO="https://github.com/xvoidsx/DarkNightsRising"

if [ -d "$GAME_DIR/.git" ]; then
  git -C "$GAME_DIR" pull --quiet 2>/dev/null || true
else
  mkdir -p "$(dirname "$GAME_DIR")"
  git clone --quiet "$REPO" "$GAME_DIR"
fi

cd "$GAME_DIR"
chmod +x intro.sh first_scene.sh second_scene.sh third_scene.sh \
  fourth_scene.sh fifth_scene.sh sixth_scene.sh seventh_scene.sh \
  eighth_scene.sh game_over.sh 2>/dev/null || true
bash intro.sh
