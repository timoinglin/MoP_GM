-- MoP_GM/UI/Tabs/Server.lua
MoP_GM.RegisterTab({
    id = "server", label = "Server",
    builder = function(parent)
        MoP_GM.LayoutRows(parent, MoP_GM.Commands.Server)
    end,
})
