-- MoP_GM/UI/Tabs/Player.lua
MoP_GM.RegisterTab({
    id = "player", label = "Player",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.Player, {
            sectionTitle = "Target / character / modify / spells",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
