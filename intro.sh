#!/usr/bin/env bash
# intro.sh — Dark Nights Rising (reawakened)
# Character creation, guided by Raven.
set -euo pipefail
source library/libdnr.sh

TITLE="DARK NIGHTS RISING"

main() {
  clear
  play_track "soundtrack/is0lation.mp3"

  printf '%s' "$DNR_MAGENTA"
  cat << 'EOF'

     ╔══════════════════════════════════════╗
     ║                                      ║
     ║         DARK NIGHTS RISING           ║
     ║                                      ║
     ╚══════════════════════════════════════╝

EOF
  printf '%s' "$DNR_OFF"
  dramatic_pause 2

  narrate "Hello. Welcome to Dark Nights Rising."
  dramatic_pause 1
  narrate "This is a game about finding yourself. But keep in mind — the journey is not about the destination, but the path it takes to get there."
  dramatic_pause 1

  raven_says "I am Raven, your guide through this game. Tell me a little about yourself."
  dramatic_pause 1

  raven_says "So, wanderer. What is your name?"
  dnr_read "  > " NAME

  raven_says "It is nice to meet you, $NAME. Now let us learn a little more."
  dramatic_pause 1

  raven_says "What would you like to call your character?"
  dnr_read "  > " CHARNAME

  raven_says "Excellent. What race will $CHARNAME hail from? Be creative."
  dnr_read "  > " RACE

  raven_says "So $CHARNAME is of the $RACE people. Where does $CHARNAME call home? Name their kingdom."
  dnr_read "  > " PLACE

  dramatic_pause 1
  narrate "So, $NAME. Your character is $CHARNAME, of the $RACE, from the kingdom of $PLACE."
  dramatic_pause 1

  local answer
  answer=$(choice "Are you happy with this character?" "Yes, let us begin." "No, start over.")
  case "$answer" in
    "Yes, let us begin.")
      cat > playerconfig.txt << EOF
NAME="$NAME"
CHARNAME="$CHARNAME"
RACE="$RACE"
PLACE="$PLACE"
SAVE_STATE_TAG=1
EOF
      raven_says "Then let us begin, $NAME. Steel yourself."
      dramatic_pause 1
      stop_track
      bash first_scene.sh
      ;;
    *)
      raven_says "Very well. Let us try again."
      sleep 1
      exec bash "$0"
      ;;
  esac
}

main
