-- MoP_GM/UI/Tabs/Bots/PlayerBot.lua
-- Sub-frame builder for the PlayerBot section of the Bots tab.

function MoP_GM.BuildPlayerBotPanel(parent)
    local scroll, content = MoP_GM.CreateScrollContent(parent)
    local h = MoP_GM.LayoutRows(content, MoP_GM.Commands.PlayerBot, {
        sectionTitle = "PlayerBot (.bot / .bots) — Emucoach reworked system",
    })
    content:SetHeight(math.max(h, 380))
end
