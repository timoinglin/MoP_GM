# MoP_GM

A movable, tabbed GM panel for World of Warcraft **Mists of Pandaria 5.4.8** clients,
targeting TrinityCore-based private servers (built and tested against the
[Emucoach](https://www.emucoach.com/) MoP repacks).

It exposes the GM commands and the PlayerBot / NpcBot commands as one-click
buttons with inline argument fields, plus a free-text command bar so anything
not buttoned is still one keystroke away.

---

## Features

- **Movable main panel** — drag the header to reposition; position is saved across sessions.
- **SHIFT-draggable launcher button** — minimap-style button anchored to the screen; SHIFT-click and drag to move it, normal click toggles the panel.
- **Tabbed layout**:
  - General (GM toggles, cheats, modify scale/speed, morph)
  - Player (appear/summon/kick, modify level/money/hp/mana, learn/reset, freeze, character ops)
  - Items (additem, additemset, removeitem, repair, restore, bank/mailbox)
  - NPC (spawn/move/say/yell, set level/faction/model, lookup, possess)
  - Object (spawn/move/turn gameobjects, lookup)
  - Teleport (free-form go/tele + a clickable list of all major MoP hubs and raids; save/delete custom names)
  - Quest (add/complete/remove/reward, lookup)
  - Server (announce, motd, shutdown/restart, save, reload `<table>`)
  - Moderation (ban/unban/mute/kick — confirmation popup on every action)
  - Bots → **PlayerBot** (`.bot` / `.bots`) and **NpcBot** (`.npcbot`) sub-tabs
  - Favorites (right-click any command button anywhere to pin it here)
  - History (last 20 commands sent; click a row to re-run)
- **Inline argument inputs** — each row has labelled input boxes that remember the last value you typed.
- **Tooltips** — hover any button to see the description and a live preview of the exact `.command` line that will be sent.
- **Confirmation popup** for destructive commands (ban, kick, shutdown, restart, reset, delete, kill, bag clear).
- **Free-text command bar** at the bottom of the panel — type any `.command` and press Enter; ↑/↓ cycle history.
- **Slash commands**: `/mopgm` or `/gm` toggles the panel; `/mopgm reset` recenters the panel and the launcher button.

---

## Install

1. Drop the `MoP_GM` folder into your client's `Interface\AddOns\` directory:
   ```
   World of Warcraft\Interface\AddOns\MoP_GM\
   ```
2. Launch the client. On the character-select screen, open **AddOns** and confirm `MoP_GM` is listed and enabled.
3. Log in. A small gear icon appears near the top-right by default — click it to open the panel, or type `/gm`.

> Make sure your account has the GM level required for the commands you intend to run. The addon doesn't elevate permissions — it only sends the chat lines on your behalf.

---

## How sending commands works

On TrinityCore-based servers, dot-commands (`.gm on`, `.additem 49623 1`, …) are processed
when sent through the chat edit box exactly like normal user input. Every button in the
addon funnels through a single helper:

```lua
function MoP_GM._ExecuteRaw(line)
    local edit = ChatEdit_ChooseBoxForSend()
    ChatEdit_ActivateChat(edit)
    edit:SetText(line)
    ChatEdit_SendText(edit, false)
    MoP_GM.PushHistory(line)
end
```

This is the most compatible idiom across Trinity forks; `SendChatMessage(".x", "SAY")`
is rejected by the client's command parser on many cores.

---

## Layout

```
MoP_GM/
├── MoP_GM.toc
├── Core/         Init, SavedVars, Util, CommandRunner
├── Data/         Commands (declarative tables) + seed teleports
└── UI/
    ├── ConfirmDialog.lua
    ├── Widgets.lua
    ├── MainFrame.lua
    ├── ToggleButton.lua
    └── Tabs/     one Lua file per tab; Bots/ holds PlayerBot.lua and NpcBot.lua
```

Each command is a table entry of the form:

```lua
{ id, label, format, args = { { key, placeholder, numeric, optional, fallback } }, danger, group, tooltip }
```

That single shape drives every visible row, the Favorites tab, the tooltip preview,
and the validate-then-build pipeline in `Core/CommandRunner.lua`.

---

## Compatibility

- Interface number **50400** (MoP 5.4.8). It will not load on other clients without changing the TOC.
- No external libraries — everything is vanilla Blizzard UI APIs available in 5.4.8.
- Designed against TrinityCore-derived cores (Emucoach, TwinStar, etc.). Every command surface is just chat input, so anything your server understands when typed will work here too.

---

## License

MIT.

---

## Thanks

- [Emucoach](https://www.emucoach.com/) for the MoP 5.4.8 repacks and PlayerBot rework.
- TrinityCore project for the canonical `.command` set.
