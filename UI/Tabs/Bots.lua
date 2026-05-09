-- MoP_GM/UI/Tabs/Bots.lua
-- Top-level Bots tab using the standard sub-tab helper.

MoP_GM.RegisterTab({
    id = "bots", label = "Bots",
    builder = function(parent)
        MoP_GM.BuildSubTabs(parent, {
            { label = "PlayerBot (.bot)",  builder = MoP_GM.BuildPlayerBotPanel },
            { label = "NpcBot (.npcbot)",  builder = MoP_GM.BuildNpcBotPanel    },
        }, "subTab_bots")
    end,
})
