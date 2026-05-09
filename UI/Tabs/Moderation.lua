-- MoP_GM/UI/Tabs/Moderation.lua
MoP_GM.RegisterTab({
    id = "moderation", label = "Moderation",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.Moderation, {
            sectionTitle = "Ban / unban / mute / kick (all confirmed)",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
