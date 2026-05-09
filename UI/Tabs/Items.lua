-- MoP_GM/UI/Tabs/Items.lua
MoP_GM.RegisterTab({
    id = "items", label = "Items",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.Items, {
            sectionTitle = "Items, bags, gear, mailbox/bank",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
