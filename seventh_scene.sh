#!/usr/bin/env bash
# new_seventh_scene.sh — Dark Nights Rising (reawakened)
# CHAPTER 7: THE GOLDEN PALACE
set -euo pipefail
source playerconfig.txt
source library/libdnr.sh

CHAPTER="CHAPTER 7"
TITLE="THE GOLDEN PALACE"
SOUNDTRACK=""

open_lines=(
  "As the Demon of Gluttony breathes his last breath a faint glimmer can be seen on the wall opposite from the cavern opening. You approach the wall and see letters in a language you don't recognize glowing faintly on the wall. A crack echoes through the cavern as another door begins to slide open. Blinding light pours though the crack as the door slides open leaving you momentarily blind."
  "Once the door is open, and your eyes have adjusted, you see that the passage beyond looks like a guilded palace. The cave walls are smooth and coated in gold, jewels jutting out in intricate patterns. If not for the musty, thick air, you would not realize that you were still stuck in a cave."
  "You look back to where the Demon of Gluttony lies and wonder what could be beyond the door. While the passageway looks more inviting than the hot, damp cavern that you are standing in, the ever present dread rises up again. You have died almost twice and you feel that there will be more close calls as you continue through the caves. Will you push on or give up?"
)

branch_a_lines=(
  "After a moment's debate you decide that moving forward is the only option. You know that if you die, you will be stuck in the cave with the demons forever, but maybe there is a chance to escape. You step through the threshold into the golden hall and the door begins to slide shut behind you. The musty air sticks in your lungs as if the passageway had not been opened for some time."
  "An eerie feeling settles over you as you walk farther into the passageway. The hall looks like it was designed for a grand king but there is no life anywhere in sight. Your footsteps echo down the hall in the silence as you press on."
)

branch_b_lines=(
  "You feel your heart pounding as you decide on what to do. Panic rises in your chest and you begin to shake with fear. The idea of moving forward is too much for you to handle after surviving a brush with death for the second time. Your legs give out and you collapse on the door. The glimmer from the writing above the door flickers out and the door begins to slide shut as you rock back and forth in your panic."
  "You faintly hear the rattle of bones as the Demon of Gluttony removes the bone from it's mouth and crawls towards you with a sharp toothed grin. You begin to scream and try to scramble away, but the demon lunges and drags you back towards him. You utter one final, guttural scream as he sinks his teeth into your neck."
)

main() {
  scene_title "$CHAPTER" "$TITLE"
  if [ -n "$SOUNDTRACK" ]; then play_track "$SOUNDTRACK"; fi

  local line
  for line in "${open_lines[@]}"; do narrate "$line"; dramatic_pause 1; done

  local answer
  answer=$(choice "What will you do?" "Keep going." "Give up." "Quit.")
  case "$answer" in
    "Keep going.")
      for line in "${branch_a_lines[@]}"; do narrate "$line"; dramatic_pause 1; done
      ;;
    "Give up.")
      for line in "${branch_b_lines[@]}"; do narrate "$line"; dramatic_pause 1; done
      ;;
    "Quit.")
      narrate "Quitting Dark Nights Rising..."
      stop_track; exit 0
      ;;
  esac

  dnr_save 8
  stop_track
  bash eighth_scene.sh
}

main
