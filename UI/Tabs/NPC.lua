-- MoP_GM/UI/Tabs/NPC.lua
MoP_GM.RegisterTab({
    id = "npc", label = "NPC",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.NPC, {
            sectionTitle = "Spawn, modify, lookup creatures",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
