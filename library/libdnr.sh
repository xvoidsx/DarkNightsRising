#!/usr/bin/env bash
# libdnr.sh v2 — Dark Nights Rising engine
#
# The cinematic core: typewriter text, character voices (piper-tts),
# scene management, and soundtrack control.
#
# Usage in scenes:
#   source library/libdnr.sh
#   scene_title "CHAPTER 1" "THE MIRROR"
#   narrate "You wake in front of an ancient mirror..."
#   raven_says "Hello, wanderer. I am Raven, your guide."
#   demon_says "I know your heart, $CHARNAME."
#   choice "What will you do?" "Stare into the mirror" "Back away" "Quit"
#
set -euo pipefail

# ── colors ──────────────────────────────────────────────
DNR_RED=$'\e[1;91m'
DNR_MAGENTA=$'\e[1;95m'
DNR_CYAN=$'\e[1;96m'
DNR_DIM=$'\e[2m'
DNR_BOLD=$'\e[1m'
DNR_OFF=$'\e[0m'

# ── voice casting ───────────────────────────────────────
# Maps characters to piper voice models. Override via env or
# dnr_config.sh. Falls back gracefully: piper → flite → espeak → silent.
DNR_VOICE_DIR="${DNR_VOICE_DIR:-$HOME/.local/share/dnr/voices}"
DNR_VOICE_RAVEN="${DNR_VOICE_RAVEN:-en_US-libritts_r-medium}"
DNR_VOICE_DEMON="${DNR_VOICE_DEMON:-en_US-ljspeech-medium}"
DNR_VOICE_NARRATOR="${DNR_VOICE_NARRATOR:-en_US-ryan-medium}"

_dnr_tts_engine() {
  if command -v piper >/dev/null 2>&1; then echo "piper"
  elif command -v flite >/dev/null 2>&1; then echo "flite"
  elif command -v espeak >/dev/null 2>&1; then echo "espeak"
  else echo "none"
  fi
}

# PID of the most recent background TTS process. Used by say_wait to
# prevent voice overlap — each line finishes speaking before the next
# begins.
_dnr_say_pid=""

_say_piper() { # <voice-model> <text>
  local model="$1" text="$2"
  local model_path="$DNR_VOICE_DIR/${model}.onnx"
  # piper requires a model file — if it's not downloaded, stay silent
  # rather than invoking piper without --model (which fails).
  if [ -f "$model_path" ] && command -v aplay >/dev/null 2>&1; then
    echo "$text" | piper --model "$model_path" --output-raw 2>/dev/null | aplay -q -r 22050 -f S16_LE -t raw - 2>/dev/null &
    _dnr_say_pid=$!
  fi
}

say() { # <character> <text> — the voice of the game
  local character="$1" text="$2"
  local engine
  engine=$(_dnr_tts_engine)
  case "$engine" in
    piper)
      case "$character" in
        raven)    _say_piper "$DNR_VOICE_RAVEN" "$text" ;;
        demon)    _say_piper "$DNR_VOICE_DEMON" "$text" ;;
        narrator) _say_piper "$DNR_VOICE_NARRATOR" "$text" ;;
        *)        _say_piper "$DNR_VOICE_NARRATOR" "$text" ;;
      esac
      ;;
    flite)
      # legacy fallback — the original DNR voices
      case "$character" in
        raven)    flite -voice rms "$text" 2>/dev/null & _dnr_say_pid=$! ;;
        demon)    flite -voice kal "$text" 2>/dev/null & _dnr_say_pid=$! ;;
        *)        flite -voice slt "$text" 2>/dev/null & _dnr_say_pid=$! ;;
      esac
      ;;
    espeak)
      espeak "$text" 2>/dev/null & _dnr_say_pid=$!
      ;;
  esac
}

say_wait() { # <character> <text> — speak and wait for the voice to finish
  _dnr_say_pid=""
  say "$1" "$2"
  if [ -n "$_dnr_say_pid" ]; then
    wait "$_dnr_say_pid" 2>/dev/null || true
  fi
  # small beat after the voice finishes before the next line
  sleep "${DNR_LINE_PAUSE:-0.5}"
}

# ── cinematic text ──────────────────────────────────────
# Typewriter with rhythm: fast on short words, pauses on punctuation.
# Set DNR_FAST=1 to skip the effect (accessibility / speedrun).

typewrite() { # <text> [color]
  local text="$1" color="${2:-}"
  if [ "${DNR_FAST:-0}" = "1" ]; then
    printf '%s%s%s\n' "$color" "$text" "$DNR_OFF"
    return
  fi
  local i char
  printf '%s' "$color"
  for (( i=0; i<${#text}; i++ )); do
    char="${text:$i:1}"
    printf '%s' "$char"
    case "$char" in
      .) sleep 0.25 ;;
      ,|\;) sleep 0.12 ;;
      [!?]) sleep 0.3 ;;
      *) sleep 0.015 ;;
    esac
  done
  printf '%s\n' "$DNR_OFF"
}

narrate() { # <text> — the narrator's voice, dim and steady
  # Print instantly so text and voice land together, then wait for the
  # voice to finish before the next line (no overlap).
  printf '%s%s%s\n' "$DNR_DIM" "$1" "$DNR_OFF"
  say_wait narrator "$1"
}

raven_says() { # <text> — Raven, your guide (cyan)
  printf '%sRaven:%s %s\n' "$DNR_CYAN" "$DNR_OFF" "$1"
  say_wait raven "$1"
}

demon_says() { # <text> — the Demon (red, slower)
  printf '%sDemon:%s %s%s%s\n' "$DNR_RED" "$DNR_OFF" "$DNR_RED" "$1" "$DNR_OFF"
  say_wait demon "$1"
}

scene_title() { # <chapter> <title>
  clear
  local chapter="$1" title="$2"
  printf '\n'
  printf '%s' "$DNR_MAGENTA"
  printf '  ╭─────────────────────────────────────╮\n'
  printf '  │                                     │\n'
  printf '  │  %-33s  │\n' "$chapter"
  printf '  │  %-33s  │\n' "$title"
  printf '  │                                     │\n'
  printf '  ╰─────────────────────────────────────╯\n'
  printf '%s' "$DNR_OFF"
  sleep 2
}

dramatic_pause() { # [seconds]
  sleep "${1:-2}"
}

# ── choices ─────────────────────────────────────────────
# Read from /dev/tty so input works even when stdin is redirected
# (e.g. launched from a desktop file or piped through a wrapper).
dnr_read() { # <prompt> <var-name>
  local prompt="$1" var="$2"
  local value
  if [ -c /dev/tty ]; then
    read -rp "$prompt" value < /dev/tty
  else
    read -rp "$prompt" value
  fi
  printf -v "$var" '%s' "$value"
}

choice() { # <prompt> <opt1> <opt2> ...
  # Simple numbered menu using dnr_read — more predictable than the
  # select builtin inside command substitution. Prints the chosen
  # option text to stdout for capture.
  local prompt="$1"; shift
  local opts=("$@")
  printf '\n%s%s%s\n' "$DNR_BOLD" "$prompt" "$DNR_OFF"
  local i reply
  for i in "${!opts[@]}"; do
    printf '  %d) %s\n' $((i+1)) "${opts[$i]}"
  done
  while true; do
    dnr_read "  > " reply
    if [[ "$reply" =~ ^[0-9]+$ ]] && [ "$reply" -ge 1 ] && [ "$reply" -le "${#opts[@]}" ]; then
      printf '%s\n' "${opts[$((reply-1))]}"
      return 0
    fi
    printf 'That isn'"'"'t a valid choice. Try again.\n' >&2
  done
}

# ── soundtrack ──────────────────────────────────────────
# Music sits under the voices. DNR_MUSIC_VOLUME is a percentage (1-100),
# default 12 — piper voices are quiet next to the soundtrack, so the
# music needs to stay well back.
DNR_MUSIC_VOLUME="${DNR_MUSIC_VOLUME:-12}"

play_track() { # <track-path>
  local track="$1"
  if [ ! -f "$track" ]; then
    return 0  # missing track — stay silent, don't error
  fi
  if command -v mpg123 >/dev/null 2>&1; then
    # -f scales 0-32768; convert percentage
    mpg123 -q -f $(( 32768 * DNR_MUSIC_VOLUME / 100 )) "$track" >/dev/null 2>&1 &
  elif command -v mpv >/dev/null 2>&1; then
    mpv --no-video --really-quiet --volume="$DNR_MUSIC_VOLUME" "$track" >/dev/null 2>&1 &
  fi
}

stop_track() {
  killall mpg123 2>/dev/null || true
  killall mpv 2>/dev/null || true
}

# ── save state ──────────────────────────────────────────
dnr_save() { # <scene-number>
  local scene="$1"
  local config="playerconfig.txt"
  if [ -f "$config" ]; then
    sed -i "s/SAVE_STATE_TAG=.*/SAVE_STATE_TAG=$scene/" "$config"
  fi
}
