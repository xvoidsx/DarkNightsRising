#!/usr/bin/env bash
# new_fifth_scene.sh — Dark Nights Rising (reawakened)
# CHAPTER 5: THE DOOR
set -euo pipefail
source playerconfig.txt
source library/libdnr.sh

CHAPTER="CHAPTER 5"
TITLE="THE DOOR"
SOUNDTRACK=""

open_lines=(
  "As the Demon of Lust breathes his last breath, you hear a cracking sound behind you. You turn to see that the door in the cavern wall is sliding open."
  "You feel a warm breeze come through as the door opens wider, a reprieve from the icy cavern. Darkness is all that can be seen beyond. Will you continue on through the door?"
)

branch_a_lines=(
  "You approach the now open door and peer into the inky depths beyond. The air is warm and dry, however it is too dark to see beyond the doorway."
  "Taking a deep breath and reminding yourself that there is no going back, you cross the threshold. The door slides closed behind you and you are envoloped in heat and darkness."
)

branch_b_lines=(
  "Instead of approaching the door, you lean against the icy side of the cavern wall, shock taking over your body after almost losing your life. You tell yourself that you just need to rest before moving on."
  "You lose track of time as you sit, eyes growing heavy. You can no longer feel the cold seeping into your bones and your body has a thin layer of ice covering it. You hear a chilling laugh as the Demon of Lust rises and approaches you as your vision fades to black."
)

main() {
  scene_title "$CHAPTER" "$TITLE"
  if [ -n "$SOUNDTRACK" ]; then play_track "$SOUNDTRACK"; fi

  local line
  for line in "${open_lines[@]}"; do narrate "$line"; dramatic_pause 1; done

  local answer
  answer=$(choice "What will you do?" "Go through the door." "Stop and rest." "Quit.")
  case "$answer" in
    "Go through the door.")
      for line in "${branch_a_lines[@]}"; do narrate "$line"; dramatic_pause 1; done
      ;;
    "Stop and rest.")
      for line in "${branch_b_lines[@]}"; do narrate "$line"; dramatic_pause 1; done
      ;;
    "Quit.")
      narrate "Quitting Dark Nights Rising..."
      stop_track; exit 0
      ;;
  esac

  dnr_save 6
  stop_track
  bash sixth_scene.sh
}

main
