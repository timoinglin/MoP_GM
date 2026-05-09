-- MoP_GM/UI/Tabs/Moderation.lua
MoP_GM.RegisterTab({
    id = "moderation", label = "Moderation",
    builder = function(parent)
        MoP_GM.LayoutRows(parent, MoP_GM.Commands.Moderation)
    end,
})
