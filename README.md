# Dark Nights Rising — Reawakened

A cinematic, text-based adventure game with voice synthesis. Aims to be playable on any GNU/Linux distribution, with minimal dependencies.

*Dark Nights Rising* is about isolation — and how the feeling of loneliness can pervade your mind. You play a wanderer guided by Raven through a series of fantasy scenarios, facing the Seven Demons (Lust, Gluttony, Greed, Sloth, Wrath, Envy, Pride) in a journey shaped by the choices you make.

Original soundtrack by [x3nyth](https://rav3ndust.xyz) (rav3ndust). Art by RyokoUmbra.

## What's new in the Reawakened edition

- **Real character voices** — [piper-tts](https://github.com/OHF-Voice/piper1-gtts) replaces the old flite robots. Raven, the Demon, and the Narrator each have their own voice. Falls back gracefully if piper isn't installed.
- **Cinematic text engine** — typewriter dialogue with rhythm and dramatic pauses, color-coded speakers, scene title cards. The story reads like it's being *performed*, not printed.
- **Unified scenes** — one clean engine (`library/libdnr.sh`), no more duplicated scripts.
- **One installer** — no more debian/arch split. Single `install.sh` handles everything.

## Play it

```bash
curl -fsSL https://raw.githubusercontent.com/xvoidsx/DarkNightsRising/main/install.sh | bash
darknightsrising
```

Or clone and run directly:

```bash
git clone https://github.com/xvoidsx/DarkNightsRising
cd DarkNightsRising
bash intro.sh
```

## Dependencies

- `piper-tts` — voice synthesis (via pipx, installed automatically)
- `mpg123` — soundtrack playback
- `dialog` — menus
- `libnotify-bin` — desktop notifications

The installer handles all of these.

## The story so far

You are a wanderer, feeling isolated and lethargic in your own home — until the world swirls, and you wake before an ancient mirror. A sinister reflection stares back. What you do next is up to you.

Eight chapters. Seven demons. One way out: through.

## Project structure

```
DarkNightsRising/
├── intro.sh              # character creation, the beginning
├── first_scene.sh        # chapter 1: the mirror
├── second_scene.sh       # chapter 2: a demonic presence
├── ...                   # chapters 3–8
├── game_over.sh          # the end (or is it?)
├── library/libdnr.sh     # the engine: voices, cinema, scenes
├── stories/              # dialogue text files
├── soundtrack/           # original music by x3nyth
├── graphics/             # art by RyokoUmbra
├── install.sh            # unified installer
└── darknightsrising.sh   # launcher (clone/update + play)
```

## Configuration

Set `DNR_FAST=1` to skip the typewriter effect (speedruns, accessibility).

Voice models live in `~/.local/share/dnr/voices/`. Override per character:

```bash
export DNR_VOICE_RAVEN="en_US-libritts_r-medium"
export DNR_VOICE_DEMON="en_US-ljspeech-medium"
export DNR_VOICE_NARRATOR="en_US-ryan-medium"
```

## License

MIT — see LICENSE.txt.
