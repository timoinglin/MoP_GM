-- MoP_GM/UI/Tabs/Quest.lua
MoP_GM.RegisterTab({
    id = "quest", label = "Quest",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.Quest, {
            sectionTitle = "Quest add / complete / lookup",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
