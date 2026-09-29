#!/usr/bin/env bash
# game_over.sh — Dark Nights Rising (reawakened)
set -euo pipefail
source playerconfig.txt
source library/libdnr.sh

SOUNDTRACK="soundtrack/is0lation.mp3"

lines=(
  "They say if you die in a dream, you die in real life."
  "This turned out to be true for $CHARNAME — who, after being killed by a Demon in the horrific state they had fallen into..."
  "...slipped from this life."
  "Nobody ever forgot $CHARNAME of $PLACE."
  "The $RACE people always remembered them as someone who met their untimely end far too soon."
  "It might be too late for $CHARNAME, but it isn't too late for you, $NAME!"
  "Would you like to restart Dark Nights Rising, or quit for now?"
  "Quitting the game will clear your data from this session."
)

main() {
  clear
  play_track "$SOUNDTRACK"

  printf '%s' "$DNR_MAGENTA"
  cat << 'EOF'

     ╔══════════════════════════════════════╗
     ║                                      ║
     ║            GAME  OVER                 ║
     ║                                      ║
     ╚══════════════════════════════════════╝

EOF
  printf '%s' "$DNR_OFF"
  dramatic_pause 2

  local line
  for line in "${lines[@]}"; do narrate "$line"; dramatic_pause 1; done

  local answer
  answer=$(choice "What will you do?" "Restart!" "Quit.")
  case "$answer" in
    "Restart!")
      narrate "Restarting the game..."
      stop_track
      bash first_scene.sh
      ;;
    "Quit.")
      narrate "Quitting Dark Nights Rising. Session data will be cleared."
      rm -f playerconfig.txt
      stop_track
      exit 0
      ;;
  esac
}

main
