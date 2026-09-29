#!/usr/bin/env bash
# third_scene.sh — Dark Nights Rising (reawakened)
# Chapter 3: Lament
set -euo pipefail
source playerconfig.txt
source library/libdnr.sh

CHAPTER="CHAPTER 3"
TITLE="LAMENT"
SOUNDTRACK="soundtrack/is0lation.mp3"

open_narrate=(
  "As the darkness dissipates and the voices fade away, you start to realize that you are in a sort of cave — a linear path forward, with only the dimmest of lights at the end."
  "With an audible rise in pitch, you hear one last voice begin to speak."
)
open_demon=(
  "Welcome to Lament, the Cave of Despair. Here, you will be forced to face your deepest nightmares and innermost fears. You will surely try to find your way out — but you will have no chance unless you confront and defeat the Seven Demons."
  "This is not a place for the faint of heart. You will surely wish yourself dead. However — here is the trick. You cannot die."
  "There are Seven Demons you must face: Lust, Gluttony, Greed, Sloth, Wrath, Envy, and Pride. To progress, you must face each one — and you will be presented with a choice. Will you make the right one? You will have to decide for yourself, $CHARNAME!"
)
open_close=(
  "Finally, the voice fades away, leaving a cacophony of emotions in its wake. You don't know how you feel about what you have just heard."
  "Do you press on, or try to find another way out? You could continue down the path — or investigate the odd mirror, hoping to escape. What will you do?"
)

continue_lines=(
  "With a deep breath and a fast-beating heart, you decide your best course of action is to press on."
  "Your footsteps echo through the narrow corridor as you step toward the dim light ahead, wondering what could possibly await you among the so-called Seven Demons."
  "'It is too late to turn back now,' you think to yourself. With an overwhelming sensation of dread, you reluctantly press on."
)

escape_lines=(
  "You decide you are not interested in seeing how this unfolds. You want out. Doubling back through the cave, you walk toward the mirror that brought you to this desolate world."
  "As you approach the glass, the voice pipes up once again."
)
escape_demon=(
  "Nice try, $CHARNAME — but there is no escape from this prison. You cannot run from your fears. What would the rest of the $RACE people think of you? You cannot be this much of a coward."
)
escape_close=(
  "With a howl, the mirror shatters to pieces, and the demon's voice fades away. You officially have no choice."
  "'It is too late to turn back now,' you think to yourself. With an overwhelming sensation of dread, you reluctantly press on."
)

main() {
  scene_title "$CHAPTER" "$TITLE"
  play_track "$SOUNDTRACK"

  local line
  for line in "${open_narrate[@]}"; do narrate "$line"; dramatic_pause 1; done
  for line in "${open_demon[@]}"; do demon_says "$line"; dramatic_pause 1; done
  for line in "${open_close[@]}"; do narrate "$line"; dramatic_pause 1; done

  local answer
  answer=$(choice "What will you do next?" "Continue." "Escape." "Quit.")
  case "$answer" in
    "Continue.")
      for line in "${continue_lines[@]}"; do narrate "$line"; dramatic_pause 1; done
      ;;
    "Escape.")
      for line in "${escape_lines[@]}"; do narrate "$line"; dramatic_pause 1; done
      for line in "${escape_demon[@]}"; do demon_says "$line"; dramatic_pause 1; done
      for line in "${escape_close[@]}"; do narrate "$line"; dramatic_pause 1; done
      ;;
    "Quit.")
      narrate "Quitting Dark Nights Rising..."
      stop_track; exit 0
      ;;
  esac

  dnr_save 4
  stop_track
  bash fourth_scene.sh
}

main
