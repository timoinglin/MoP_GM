-- MoP_GM/UI/Tabs/Bots/NpcBot.lua
-- Sub-frame builder for the NpcBot section of the Bots tab.

function MoP_GM.BuildNpcBotPanel(parent)
    local scroll, content = MoP_GM.CreateScrollContent(parent)
    local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.NpcBot, {
        sectionTitle = "NpcBot (.npcbot) — older system",
    })
    content:SetHeight(math.max(h, 380))
end
