-- MoP_GM/UI/Tabs/Moderation.lua
MoP_GM.RegisterTab({
    id = "moderation", label = "Moderation",
    builder = function(parent)
        MoP_GM.BuildSubTabs(parent, {
            { label = "Bans",          rows = MoP_GM.Commands.ModerationBan  },
            { label = "Mute / Inspect",rows = MoP_GM.Commands.ModerationMute },
        }, "subTab_moderation")
    end,
})
