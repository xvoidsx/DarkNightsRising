#!/usr/bin/env bash
# second_scene.sh — Dark Nights Rising (reawakened)
# Chapter 2: A Demonic Presence
set -euo pipefail
source playerconfig.txt
source library/libdnr.sh

CHAPTER="CHAPTER 2"
TITLE="A DEMONIC PRESENCE"
SOUNDTRACK="soundtrack/c0py_(of-a-c0py).mp3"

# opening narration
open_lines=(
  "After a strong sensation of being lifted into the air, and a general feeling of being dazed and confused, you wonder if the whole experience was real or not."
  "Suddenly, with no warning at all, you hear the sound of laughter — a shrill collection of voices calling out to you, as if they know exactly who you are."
  "The voices speak the following words:"
)
demon_open=(
  "Hello, $CHARNAME. We have always known you, we have always followed you. We know your every thought, we know every single move you make. You cannot hide anything from us, and you can have no secrets."
  "Now, $CHARNAME of the $RACE race, from the land of $PLACE — don't try to hide your true character. Allow yourself to be assimilated by your deepest desires. We can help you feel like you have a purpose again."
)
open_close=(
  "You do not know what to do. You are conflicted. Are these demons telling you the truth? Or are they conspiring against you to take control of your mind?"
  "Think carefully, because you only get one chance here."
)

# RESIST branch
resist_lines=(
  "'I refuse,' you say calmly to the demons. 'I will not assimilate with you. I refuse to give you any control over my brain.'"
  "The demons are not happy about your decision. They shout a shrill, hellish scream, bringing the very feeling of dread itself into your soul."
  "Next, the demons have this to say:"
)
resist_demon=(
  "How dare you defy us! You will pay for this with the ultimate retribution. We already have control over your mind, don't you see? We exist within you, a part of your very being!"
  "You will roam the dark halls of your disturbed mind for years, and you will never find a true escape. We will torment you in a prison of your own creation until the day you die."
)
resist_close=(
  "You breathe a sigh of relief. The demons have vanished, for now. Knowing they will be back, you take a deep breath, determined, and press on through the dark corridor in front of you — feeling as though you are being watched the whole time."
  "It is not over yet. To get out of this nightmare, it is going to truly take confronting these demons at some point. The question is: will you be ready when you encounter them again?"
)

# ASSIMILATE branch
assimilate_lines=(
  "'I will join you,' you say to the demons. 'I have been facing this mental lapse for far too long. I am ready for some kind of reprieve.'"
  "The demons laugh, staring at you with intent."
)
assimilate_demon=(
  "You really thought it would be that easy? We owe you a lifetime of darkness and retribution for the sins you have committed in your life. This is your own mental prison, and we are the gatekeepers."
  "Just wait. We are going to force you to traverse the hallways of your disturbed mind, and show you exactly the sins you have committed throughout the years."
  "We will be back. Your day of reckoning is upon you, $CHARNAME."
)
assimilate_close=(
  "You take a deep breath as the demons finally stop shouting and vanish into thin air. With a fast-beating heart and no idea what to expect next, you know it is time to press on."
  "It is not over yet. To get out of this nightmare, it is going to truly take confronting these demons at some point. The question is: will you be ready when you encounter them again?"
)

play_branch() { # <prefix> — plays lines, demon_lines, close_lines arrays
  local prefix="$1"
  local -n lines="${prefix}_lines"
  local -n dlines="${prefix}_demon"
  local -n close="${prefix}_close"
  local line
  for line in "${lines[@]}"; do narrate "$line"; dramatic_pause 1; done
  for line in "${dlines[@]}"; do demon_says "$line"; dramatic_pause 1; done
  for line in "${close[@]}"; do narrate "$line"; dramatic_pause 1; done
}

main() {
  scene_title "$CHAPTER" "$TITLE"
  play_track "$SOUNDTRACK"

  local line
  for line in "${open_lines[@]}"; do narrate "$line"; dramatic_pause 1; done
  for line in "${demon_open[@]}"; do demon_says "$line"; dramatic_pause 1; done
  for line in "${open_close[@]}"; do narrate "$line"; dramatic_pause 1; done

  local answer
  answer=$(choice "What do you choose to do?" "Resist" "Assimilate" "Quit")
  case "$answer" in
    "Resist")     play_branch "resist" ;;
    "Assimilate") play_branch "assimilate" ;;
    "Quit")
      narrate "Quitting Dark Nights Rising..."
      stop_track; exit 0
      ;;
  esac

  dnr_save 3
  stop_track
  bash third_scene.sh
}

main
