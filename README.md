# MoP_GM

[![Latest release](https://img.shields.io/github/v/release/timoinglin/MoP_GM?style=flat-square&color=33aa33)](https://github.com/timoinglin/MoP_GM/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/timoinglin/MoP_GM/total?style=flat-square)](https://github.com/timoinglin/MoP_GM/releases)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](LICENSE)
[![WoW client](https://img.shields.io/badge/WoW-5.4.8%20MoP-9534b1?style=flat-square)](https://www.emucoach.com/)

A clean, movable GM panel for **World of Warcraft Mists of Pandaria 5.4.8** private servers — built and tested against [Emucoach](https://www.emucoach.com/) repacks (TrinityCore-based).

Every common GM command is one click away, with input fields right next to each command. PlayerBot and NpcBot management included.

### ⬇ [Download the latest release](https://github.com/timoinglin/MoP_GM/releases/latest/download/MoP_GM.zip)

---

## Screenshots

![General tab — GM toggles, cheats, modify](screenshots/general.jpg)
*General tab with the **Toggles** and **Cheats & Modify** sub-tabs.*

![Player tab — character ops](screenshots/player.jpg)
*Player tab with sub-tabs for Target, Modify, Spells, and Reset.*

![Server tab — admin commands](screenshots/server.jpg)
*Server tab — announce, motd, save, shutdown/restart, reload tables.*

---

## Install

1. **Download** the zip: [MoP_GM.zip](https://github.com/timoinglin/MoP_GM/releases/latest/download/MoP_GM.zip)
2. **Extract** the `MoP_GM` folder into your client's AddOns directory:
   ```
   World of Warcraft\Interface\AddOns\MoP_GM\
   ```
   The folder must contain `MoP_GM.toc` directly — i.e. the path `…\Interface\AddOns\MoP_GM\MoP_GM.toc` should exist.
3. **Launch** the game. On the character-select screen, open **AddOns** and confirm `MoP_GM` is listed and enabled.
4. **Log in.** A small gear icon appears next to your minimap — click it to open the panel, or type `/gm` in chat.

> ℹ Your account needs the GM level required for the commands you intend to run. The addon doesn't elevate permissions — it just sends the chat lines on your behalf.

---

## How to use

| Action | Result |
|---|---|
| **Click** a command label | Runs the command using the values in the input fields |
| **Press Enter** in any input field | Runs the command for that row |
| **Right-click** any command label | Pin / unpin it from the **Favorites** tab |
| **SHIFT-drag** the minimap button | Move the launcher button anywhere on screen |
| **Drag the panel header** | Move the main panel |
| **Click the X** on the panel header | Close the panel |
| `/gm` *or* `/mopgm` | Toggle the panel |
| `/mopgm reset` | Recenter panel and minimap button |
| `/mopgm debug` | Print module load status (for troubleshooting) |

Destructive commands (ban, kick, server shutdown, reset, delete, …) show a confirmation popup before sending.

---

## Tabs

| Tab | What's inside |
|---|---|
| **General** | GM toggles (`.gm on/off`, fly, visible), cheat suite (god, power, cooldown, casttime, waterwalk, explore), morph, mount, modify scale/speed/swim/fly |
| **Player** | Appear/summon/kick, modify level/money/hp/mana/honor, learn/cast/aura, reset talents/spells/skills, character rename / changerace / changefaction, freeze, unstuck |
| **Items** | additem, additemset, removeitem, repair, item restore, bank, void storage, mailbox |
| **NPC** | Spawn, move, say/yell/whisper/emote, possess, modify level/faction/model, lookup |
| **Object** | Spawn, move, turn, lookup gameobjects |
| **Teleport** | Free-form `.tele`/`.go` commands plus a clickable grid of every major MoP location (capitals, shrines, zones, raids); save/delete custom names |
| **Quest** | add / complete / remove / reward, lookup |
| **Server** | announce, motd, save, shutdown / restart, reload tables |
| **Moderation** | ban / unban / mute / kick — all destructive, all with confirmation popup |
| **Bots** | **PlayerBot** (`.bot` / `.bots`) and **NpcBot** (`.npcbot`) sub-tabs |
| **Favorites** | Your pinned commands, persisted across sessions |
| **History** | Last 20 commands you sent — click any to re-run |

Tabs with many commands are split into **sub-tabs** so nothing scrolls and the UI stays snappy.

---

## Compatibility

- WoW client **5.4.8** (interface 50400). It will not load on other clients without changing the TOC.
- Designed for **TrinityCore-based** servers (Emucoach, TwinStar, etc.). Every command is sent as a regular chat message; the server intercepts dot-commands before broadcasting.
- No external libraries — uses only the built-in WoW UI APIs available in 5.4.8.

---

## Troubleshooting

If something looks wrong, run `/mopgm debug` in chat. It prints whether each module loaded and whether the main frame and toggle button were created. If any module shows `MISSING`, that file failed to load — copy the output and open an issue.

If the toggle button is hidden behind the minimap or off-screen, run `/mopgm reset` to recenter it.

---

## License

[MIT](LICENSE) — do whatever you want with it.

---

## Credits

- [Emucoach](https://www.emucoach.com/) for the MoP 5.4.8 repacks and the reworked PlayerBot system.
- TrinityCore for the canonical `.command` set.
