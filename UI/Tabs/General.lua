-- MoP_GM/UI/Tabs/General.lua
MoP_GM.RegisterTab({
    id = "general", label = "General",
    builder = function(parent)
        MoP_GM.BuildSubTabs(parent, {
            { label = "Toggles",         rows = MoP_GM.Commands.GeneralToggles },
            { label = "Cheats & Modify", rows = MoP_GM.Commands.GeneralCheats  },
        }, "subTab_general")
    end,
})
