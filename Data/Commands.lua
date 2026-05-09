-- MoP_GM/Data/Commands.lua
-- Declarative command definitions consumed by UI/Tabs/*.
--
-- Each entry shape:
--   { id, label, format, args = { { key, placeholder, numeric, optional, fallback } }, danger, group, tooltip }
--
-- `format` is fed to string.format with one %s per arg (in declaration order).
-- `danger=true` triggers a confirm dialog before sending.
-- `fallback="target"` lets a blank field fall back to UnitName("target").

MoP_GM.Commands = {}
local C = MoP_GM.Commands

local function nameArg(opts)
    opts = opts or {}
    return { key = "name", placeholder = opts.placeholder or "player", fallback = "target", optional = opts.optional }
end

-- ─── General / GM toggles ──────────────────────────────────────────────────
C.General = {
    { id="gmon",      label=".gm on",           format=".gm on",          tooltip="Enter GM mode (invisible to non-GMs)." },
    { id="gmoff",     label=".gm off",          format=".gm off",         tooltip="Leave GM mode." },
    { id="gmflyon",   label=".gm fly on",       format=".gm fly on",      tooltip="Toggle flying anywhere on." },
    { id="gmflyoff",  label=".gm fly off",      format=".gm fly off",     tooltip="Toggle flying off." },
    { id="gmvis",     label=".gm visible",      format=".gm visible",     tooltip="Toggle GM visibility." },
    { id="gmingame",  label=".gm ingame",       format=".gm ingame",      tooltip="List online GMs." },
    { id="gps",       label=".gps",             format=".gps",            tooltip="Print current map / x / y / z." },
    { id="commands",  label=".commands",        format=".commands",       tooltip="Print server-supported commands." },
    { id="taxicheat", label=".taxicheat on",    format=".taxicheat on",   tooltip="Reveal all flight masters." },
    { id="taxicheato",label=".taxicheat off",   format=".taxicheat off",  tooltip="Hide all flight masters again." },

    { id="cheatgod",  label="cheat god",        format=".cheat god %s",   args={{key="state",placeholder="on/off"}}, tooltip="Toggle invulnerability." },
    { id="cheatpwr",  label="cheat power",      format=".cheat power %s", args={{key="state",placeholder="on/off"}}, tooltip="Infinite mana/rage/energy." },
    { id="cheatcd",   label="cheat cooldown",   format=".cheat cooldown %s",args={{key="state",placeholder="on/off"}}, tooltip="No cooldowns." },
    { id="cheatct",   label="cheat casttime",   format=".cheat casttime %s",args={{key="state",placeholder="on/off"}}, tooltip="Instant casts." },
    { id="cheatww",   label="cheat waterwalk",  format=".cheat waterwalk %s",args={{key="state",placeholder="on/off"}}, tooltip="Walk on water." },
    { id="cheatexp",  label="cheat explore",    format=".cheat explore %s",args={{key="state",placeholder="on/off"}}, tooltip="Reveal map." },
    { id="cheatstat", label="cheat status",     format=".cheat status",   tooltip="Print active cheats." },

    { id="morph",     label="morph",            format=".morph %s",       args={{key="displayid",placeholder="displayId",numeric=true}}, tooltip="Change model." },
    { id="demorph",   label="demorph",          format=".demorph",        tooltip="Revert to default model." },
    { id="mount",     label="mount",            format=".mount %s",       args={{key="mountid",placeholder="mountId",numeric=true}}, tooltip="Mount creature display id." },
    { id="dismount",  label="dismount",         format=".dismount",       tooltip="Dismount." },
    { id="modscale",  label="modify scale",     format=".modify scale %s",args={{key="scale",placeholder="0.1-10",numeric=true}}, tooltip="Resize player." },
    { id="modspeed",  label="modify speed",     format=".modify speed %s",args={{key="rate",placeholder="0.1-50",numeric=true}}, tooltip="Movement speed multiplier." },
    { id="modswim",   label="modify swim",      format=".modify swim %s", args={{key="rate",placeholder="0.1-50",numeric=true}}, tooltip="Swim speed multiplier." },
    { id="modfly",    label="modify fly",       format=".modify fly %s",  args={{key="rate",placeholder="0.1-50",numeric=true}}, tooltip="Flight speed multiplier." },
}

-- ─── Player ────────────────────────────────────────────────────────────────
C.Player = {
    { id="appear",   label="appear",   format=".appear %s",  args={ nameArg() }, tooltip="Teleport to player." },
    { id="summon",   label="summon",   format=".summon %s",  args={ nameArg() }, tooltip="Summon player to you." },
    { id="recall",   label="recall",   format=".recall %s",  args={ nameArg{ optional=true } }, tooltip="Teleport player back to recall position." },
    { id="kick",     label="kick",     format=".kick %s",    args={ nameArg() }, tooltip="Disconnect player.", danger=true },
    { id="kill",     label="kill",     format=".kill %s",    args={ nameArg{ optional=true } }, tooltip="Kill target/named unit.", danger=true },
    { id="revive",   label="revive",   format=".revive %s",  args={ nameArg{ optional=true } }, tooltip="Revive target/named player." },
    { id="freeze",   label="freeze",   format=".freeze %s",  args={ nameArg{ optional=true } }, tooltip="Freeze player in place." },
    { id="unfreeze", label="unfreeze", format=".unfreeze %s",args={ nameArg{ optional=true } }, tooltip="Unfreeze player." },
    { id="playerinfo",label="playerinfo",format=".pinfo",    tooltip="Detailed info on selected player." },

    { id="modlevel", label="modify level", format=".modify level %s", args={{key="level",placeholder="1-90",numeric=true}}, tooltip="Set target level." },
    { id="modxp",    label="modify xp",    format=".modify xp %s",    args={{key="xp",placeholder="amount",numeric=true}}, tooltip="Set target XP." },
    { id="modmoney", label="modify money", format=".modify money %s", args={{key="copper",placeholder="copper",numeric=true}}, tooltip="Add copper to target." },
    { id="modhp",    label="modify hp",    format=".modify hp %s",    args={{key="hp",placeholder="hp",numeric=true}} },
    { id="modmana",  label="modify mana",  format=".modify mana %s",  args={{key="mana",placeholder="mana",numeric=true}} },
    { id="modrage",  label="modify rage",  format=".modify rage %s",  args={{key="rage",placeholder="rage",numeric=true}} },
    { id="modenergy",label="modify energy",format=".modify energy %s",args={{key="energy",placeholder="energy",numeric=true}} },
    { id="modhonor", label="modify honor", format=".modify honor %s", args={{key="amount",placeholder="amount",numeric=true}} },
    { id="modarena", label="modify arena", format=".modify arena %s", args={{key="amount",placeholder="amount",numeric=true}} },
    { id="modphase", label="modify phase", format=".modify phase %s", args={{key="mask",placeholder="phaseMask",numeric=true}} },
    { id="modgender",label="modify gender",format=".modify gender %s",args={{key="gender",placeholder="0=M 1=F",numeric=true}} },
    { id="modrep",   label="modify rep",   format=".modify reputation %s %s",args={{key="faction",placeholder="factionId",numeric=true},{key="value",placeholder="value",numeric=true}} },

    { id="learn",    label="learn",        format=".learn %s",        args={{key="spellid",placeholder="spellId",numeric=true}}, tooltip="Teach a spell." },
    { id="learnclass",label="learn all my class",format=".learn all my class", tooltip="Teach all spells of my class." },
    { id="learnrec", label="learn all recipes",  format=".learn all recipes", tooltip="Teach every profession recipe." },
    { id="unlearn",  label="unlearn",      format=".unlearn %s",      args={{key="spellid",placeholder="spellId",numeric=true}} },
    { id="cast",     label="cast",         format=".cast %s",         args={{key="spellid",placeholder="spellId",numeric=true}} },
    { id="castself", label="cast self",    format=".cast self %s",    args={{key="spellid",placeholder="spellId",numeric=true}} },
    { id="aura",     label="aura",         format=".aura %s",         args={{key="spellid",placeholder="spellId",numeric=true}} },
    { id="unaura",   label="unaura",       format=".unaura %s",       args={{key="spellid",placeholder="spellId",numeric=true}} },
    { id="cdall",    label="cooldown all", format=".cooldown",        tooltip="Clear all cooldowns on target." },

    { id="rsttalents",label="reset talents",format=".reset talents %s",args={ nameArg{ optional=true } }, danger=true },
    { id="rstspells",label="reset spells", format=".reset spells %s", args={ nameArg{ optional=true } }, danger=true },
    { id="rstskills",label="reset skills", format=".reset skills",    tooltip="Reset target's skills.", danger=true },
    { id="rstall",   label="reset all",    format=".reset all %s",    args={{key="kind",placeholder="talents/spells/stats"}}, danger=true },
    { id="rststats", label="reset stats",  format=".reset stats",     danger=true },
    { id="rstlevel", label="reset level",  format=".reset level %s",  args={ nameArg{ optional=true } }, danger=true },

    { id="maxskill", label="maxskill",     format=".maxskill" },
    { id="setskill", label="setskill",     format=".setskill %s %s %s",args={{key="skill",placeholder="skillId",numeric=true},{key="value",placeholder="value",numeric=true},{key="max",placeholder="max",numeric=true,optional=true}} },

    { id="charrename", label="character rename",   format=".character rename %s",  args={ nameArg() } },
    { id="charcust",   label="character customize",format=".character customize %s",args={ nameArg() } },
    { id="charcrace",  label="changerace",         format=".character changerace %s",args={ nameArg() } },
    { id="charcfac",   label="changefaction",      format=".character changefaction %s",args={ nameArg() } },

    { id="unstuck",  label="unstuck",      format=".unstuck %s",      args={ nameArg{ optional=true } } },
    { id="bindsight",label="bindsight",    format=".bindsight" },
    { id="unbindsight",label="unbindsight",format=".unbindsight" },
    { id="hover",    label="hover",        format=".hover %s",        args={{key="state",placeholder="0/1",numeric=true}} },
}

-- ─── Items ─────────────────────────────────────────────────────────────────
C.Items = {
    { id="additem",  label="additem",   format=".additem %s %s", args={{key="id",placeholder="itemId",numeric=true},{key="count",placeholder="count",numeric=true,optional=true,default="1"}}, tooltip="Add item to your bags." },
    { id="addset",   label="additemset",format=".additemset %s", args={{key="setid",placeholder="setId",numeric=true}}, tooltip="Add an entire item set." },
    { id="addtoset", label="additemtoset",format=".additemtoset %s %s",args={{key="set",placeholder="setId",numeric=true},{key="item",placeholder="itemId",numeric=true}}, optional=true },
    { id="rmitem",   label="removeitem",format=".removeitem %s %s",args={{key="id",placeholder="itemId",numeric=true},{key="count",placeholder="count",numeric=true,optional=true,default="1"}} },
    { id="bagsclr",  label="bags clear",format=".bag clear %s",  args={{key="quality",placeholder="poor/all",optional=true,default="all"}}, danger=true },
    { id="repair",   label="gear repair",format=".repairitems",  tooltip="Repair all items on target." },
    { id="restore",  label="item restore",format=".item restore %s %s",args={{key="itemid",placeholder="itemId",numeric=true},{key="player",placeholder="player"}} },
    { id="restorelist",label="item restore list",format=".item restore list %s",args={ nameArg{ optional=true } } },
    { id="bank",     label="bank",       format=".bank", tooltip="Open bank for target." },
    { id="vbank",    label="void storage",format=".voidstorage" },
    { id="reagb",    label="reagent bank",format=".reagentbank" },
    { id="mailbox",  label="mailbox",    format=".mailbox" },
    { id="ah",       label="ah",         format=".ahbot" },
}

-- ─── NPC ───────────────────────────────────────────────────────────────────
C.NPC = {
    { id="npcadd",   label="npc add",     format=".npc add %s",     args={{key="entry",placeholder="creatureId",numeric=true}} },
    { id="npcaddtmp",label="npc add temp",format=".npc add temp %s",args={{key="entry",placeholder="creatureId",numeric=true}} },
    { id="npcdel",   label="npc delete",  format=".npc delete",     danger=true },
    { id="npcmove",  label="npc move",    format=".npc move",       tooltip="Move selected creature here." },
    { id="npcinfo",  label="npc info",    format=".npc info" },
    { id="npcsay",   label="npc say",     format=".npc say %s",     args={{key="text",placeholder="text"}} },
    { id="npcyell",  label="npc yell",    format=".npc yell %s",    args={{key="text",placeholder="text"}} },
    { id="npcwhisp", label="npc whisper", format=".npc whisper %s %s",args={ nameArg(),{key="text",placeholder="text"}} },
    { id="npcemote", label="npc emote",   format=".npc playemote %s",args={{key="emote",placeholder="emoteId",numeric=true}} },
    { id="npcfollow",label="npc follow",  format=".npc follow start" },
    { id="npcunfo",  label="npc unfollow",format=".npc follow stop" },
    { id="npccome",  label="npc come",    format=".npc come" },
    { id="npcposs",  label="npc possess", format=".possess" },
    { id="npcunposs",label="npc unposs",  format=".unpossess" },

    { id="npcsetlvl",label="npc set level",  format=".npc set level %s",   args={{key="level",placeholder="1-90",numeric=true}} },
    { id="npcsetfac",label="npc set faction",format=".npc set faction %s", args={{key="faction",placeholder="factionId",numeric=true}} },
    { id="npcsetmod",label="npc set model",  format=".npc set model %s",   args={{key="modelid",placeholder="modelId",numeric=true}} },
    { id="npcsetmt", label="npc set movetype",format=".npc set movetype %s",args={{key="type",placeholder="0=idle 1=rand 2=wp",numeric=true}} },
    { id="npcsetent",label="npc set entry",  format=".npc set entry %s",   args={{key="entry",placeholder="creatureId",numeric=true}} },
    { id="npcsetphs",label="npc set phase",  format=".npc set phase %s",   args={{key="phase",placeholder="phaseMask",numeric=true}} },
    { id="npcsetfly",label="npc set fly",    format=".npc set flag %s",    args={{key="flag",placeholder="flagBits",numeric=true}} },

    { id="lookcreat",label="lookup creature", format=".lookup creature %s", args={{key="text",placeholder="search"}} },
    { id="respawn",  label="respawn",          format=".respawn" },
    { id="repopall", label="repopall",         format=".repopall" },
    { id="die",      label="die",              format=".die",            danger=true },
    { id="damage",   label="damage",           format=".damage %s",      args={{key="amount",placeholder="amount",numeric=true}} },
}

-- ─── GameObject ────────────────────────────────────────────────────────────
C.GameObject = {
    { id="goadd",   label="gobject add",   format=".gobject add %s %s", args={{key="entry",placeholder="objectId",numeric=true},{key="resp",placeholder="respawn",numeric=true,optional=true}} },
    { id="godel",   label="gobject delete",format=".gobject delete %s", args={{key="guid",placeholder="guid",numeric=true,optional=true}}, danger=true },
    { id="gomove",  label="gobject move",  format=".gobject move %s",   args={{key="guid",placeholder="guid",numeric=true,optional=true}} },
    { id="goturn",  label="gobject turn",  format=".gobject turn %s",   args={{key="orient",placeholder="orientation",numeric=true,optional=true}} },
    { id="gonear",  label="gobject near",  format=".gobject near %s",   args={{key="dist",placeholder="distance",numeric=true,optional=true,default="10"}} },
    { id="gotrgt",  label="gobject target",format=".gobject target %s", args={{key="entry",placeholder="objectId",numeric=true,optional=true}} },
    { id="goinfo",  label="gobject info",  format=".gobject info" },
    { id="goactv",  label="gobject activate",format=".gobject activate %s", args={{key="guid",placeholder="guid",numeric=true,optional=true}} },
    { id="lookobj", label="lookup object", format=".lookup object %s",  args={{key="text",placeholder="search"}} },
}

-- ─── Quest ─────────────────────────────────────────────────────────────────
C.Quest = {
    { id="qadd",    label="quest add",     format=".quest add %s",     args={{key="id",placeholder="questId",numeric=true}} },
    { id="qcomp",   label="quest complete",format=".quest complete %s",args={{key="id",placeholder="questId",numeric=true}} },
    { id="qrem",    label="quest remove",  format=".quest remove %s",  args={{key="id",placeholder="questId",numeric=true}} },
    { id="qreward", label="quest reward",  format=".quest reward %s",  args={{key="id",placeholder="questId",numeric=true}} },
    { id="qlook",   label="lookup quest",  format=".lookup quest %s",  args={{key="text",placeholder="search"}} },
}

-- ─── Server / Admin ────────────────────────────────────────────────────────
C.Server = {
    { id="announce", label="announce",      format=".announce %s",   args={{key="msg",placeholder="message"}} },
    { id="wann",     label="wide announce", format=".wannounce %s",  args={{key="msg",placeholder="message"}} },
    { id="srvinfo",  label="server info",   format=".server info" },
    { id="srvmotd",  label="server motd",   format=".server motd" },
    { id="setmotd",  label="set motd",      format=".server set motd %s",args={{key="msg",placeholder="message"}} },
    { id="srvshut",  label="server shutdown",format=".server shutdown %s %s",args={{key="seconds",placeholder="seconds",numeric=true},{key="reason",placeholder="reason",optional=true}}, danger=true },
    { id="srvrestart",label="server restart",format=".server restart %s %s",args={{key="seconds",placeholder="seconds",numeric=true},{key="reason",placeholder="reason",optional=true}}, danger=true },
    { id="srvcancel",label="cancel restart",format=".server shutdown cancel" },
    { id="save",     label="save",          format=".save",          tooltip="Save target character." },
    { id="saveall",  label="saveall",       format=".saveall" },
    { id="reload",   label="reload table",  format=".reload %s",     args={{key="table",placeholder="creature_template / quest_template / …"}} },
}

-- ─── Moderation (all destructive → confirm) ───────────────────────────────
C.Moderation = {
    { id="banacc",   label="ban account",  format=".ban account %s %s %s",args={ nameArg{placeholder="account"},{key="dur",placeholder="1d/perm"},{key="reason",placeholder="reason"} }, danger=true },
    { id="banchar",  label="ban character",format=".ban character %s %s %s",args={ nameArg(),{key="dur",placeholder="1d/perm"},{key="reason",placeholder="reason"} }, danger=true },
    { id="banip",    label="ban ip",       format=".ban ip %s %s %s",  args={{key="ip",placeholder="ip"},{key="dur",placeholder="1d/perm"},{key="reason",placeholder="reason"}}, danger=true },
    { id="unbanacc", label="unban account",format=".unban account %s", args={ nameArg{placeholder="account"} } },
    { id="unbanchar",label="unban character",format=".unban character %s", args={ nameArg() } },
    { id="unbanip",  label="unban ip",     format=".unban ip %s",      args={{key="ip",placeholder="ip"}} },
    { id="mute",     label="mute",         format=".mute %s %s %s",    args={ nameArg(),{key="minutes",placeholder="minutes",numeric=true},{key="reason",placeholder="reason",optional=true} }, danger=true },
    { id="unmute",   label="unmute",       format=".unmute %s",        args={ nameArg() } },
    { id="kickmod",  label="kick",         format=".kick %s %s",       args={ nameArg(),{key="reason",placeholder="reason",optional=true} }, danger=true },
    { id="warden",   label="warden check", format=".wardencheck" },
}

-- ─── PlayerBot (.bot / .bots) ──────────────────────────────────────────────
C.PlayerBot = {
    { id="botadd",   label="bot add",       format=".bot add %s %s", args={{key="role",placeholder="1=heal 2=dps 3=tank",numeric=true},{key="qty",placeholder="qty",numeric=true,optional=true,default="1"}}, tooltip="Add bots to your group by role." },
    { id="botattack",label="bot attack",    format=".bot attack",    tooltip="Order bots to attack your target." },
    { id="botfollow",label="bot follow on", format=".bot follow 1",  tooltip="Bots follow you." },
    { id="botstop",  label="bot follow off",format=".bot follow 0",  tooltip="Bots stay." },
    { id="botaggr",  label="bot aggressive on",format=".bot aggressive 1" },
    { id="botpassv", label="bot aggressive off",format=".bot aggressive 0" },
    { id="botsrole", label=".bots role",    format=".bots role %s",  args={{key="role",placeholder="1=heal 2=dps 3=tank",numeric=true}} },
    { id="botsadd",  label=".bots add to group",format=".bots addRoleBotsToGroup %s %s",args={{key="role",placeholder="1=heal 2=dps 3=tank",numeric=true},{key="amount",placeholder="amount",numeric=true}} },
    { id="botremove",label="bot remove",    format=".bot remove %s", args={ nameArg{placeholder="bot name", optional=true} }, danger=true },
}

-- ─── NpcBot (.npcbot) ─────────────────────────────────────────────────────
C.NpcBot = {
    { id="nbhelp",   label="npcbot help",     format=".npcbot",        tooltip="List subcommands." },
    { id="nbadd",    label="npcbot add",      format=".npcbot add %s", args={{key="class",placeholder="warrior/mage/…"}} },
    { id="nbrem",    label="npcbot remove",   format=".npcbot remove", danger=true },
    { id="nbfollow", label="npcbot follow",   format=".npcbot command follow" },
    { id="nbstay",   label="npcbot stay",     format=".npcbot command stay" },
    { id="nbdist",   label="npcbot distance", format=".npcbot distance %s",args={{key="dist",placeholder="distance",numeric=true}} },
    { id="nbreset",  label="npcbot reset",    format=".npcbot reset",  danger=true },
    { id="nbinfo",   label="npcbot info",     format=".npcbot info" },
    { id="nbmaint",  label="set maintank",    format=".maintank" },
}

-- Stamp a `group` field onto every entry so favorites can key by group:id.
for groupName, list in pairs(C) do
    for _, def in ipairs(list) do
        def.group = groupName
    end
end
