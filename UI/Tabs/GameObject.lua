-- MoP_GM/UI/Tabs/GameObject.lua
MoP_GM.RegisterTab({
    id = "gobject", label = "Object",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.GameObject, {
            sectionTitle = "GameObject spawn / move / lookup",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
