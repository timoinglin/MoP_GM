-- MoP_GM/UI/Tabs/General.lua
MoP_GM.RegisterTab({
    id = "general", label = "General",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.General, {
            sectionTitle = "GM toggles, cheats, modify",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
