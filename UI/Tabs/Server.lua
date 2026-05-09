-- MoP_GM/UI/Tabs/Server.lua
MoP_GM.RegisterTab({
    id = "server", label = "Server",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)
        local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.Server, {
            sectionTitle = "Announce, server, save, reload",
        })
        content:SetHeight(math.max(h, 400))
    end,
})
