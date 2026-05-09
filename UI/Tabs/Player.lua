-- MoP_GM/UI/Tabs/Player.lua
MoP_GM.RegisterTab({
    id = "player", label = "Player",
    builder = function(parent)
        MoP_GM.BuildSubTabs(parent, {
            { label = "Target",     rows = MoP_GM.Commands.PlayerTarget },
            { label = "Modify",     rows = MoP_GM.Commands.PlayerModify },
            { label = "Spells",     rows = MoP_GM.Commands.PlayerSpells },
            { label = "Reset & Char", rows = MoP_GM.Commands.PlayerReset },
        }, "subTab_player")
    end,
})
