-- MoP_GM/UI/Tabs/Bots.lua
-- Top-level Bots tab containing two sub-tabs: PlayerBot and NpcBot.

MoP_GM.RegisterTab({
    id = "bots", label = "Bots",
    builder = function(parent)
        local subStrip = CreateFrame("Frame", nil, parent)
        subStrip:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -4)
        subStrip:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -4, -4)
        subStrip:SetHeight(26)

        local subContent = CreateFrame("Frame", nil, parent)
        subContent:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -32)
        subContent:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -4, 4)

        local pbPanel = CreateFrame("Frame", nil, subContent)
        pbPanel:SetAllPoints(subContent)
        pbPanel:Hide()
        MoP_GM.BuildPlayerBotPanel(pbPanel)

        local nbPanel = CreateFrame("Frame", nil, subContent)
        nbPanel:SetAllPoints(subContent)
        nbPanel:Hide()
        MoP_GM.BuildNpcBotPanel(nbPanel)

        local function selectSub(idx)
            if idx == 1 then pbPanel:Show(); nbPanel:Hide()
            else                pbPanel:Hide(); nbPanel:Show() end
            MoP_GM.db.activeBotsSubTab = idx
        end

        local pbBtn = CreateFrame("Button", nil, subStrip, "UIPanelButtonTemplate")
        pbBtn:SetSize(140, 22); pbBtn:SetText("PlayerBot (.bot)")
        pbBtn:SetPoint("LEFT", subStrip, "LEFT", 8, 0)
        pbBtn:SetScript("OnClick", function() selectSub(1) end)

        local nbBtn = CreateFrame("Button", nil, subStrip, "UIPanelButtonTemplate")
        nbBtn:SetSize(140, 22); nbBtn:SetText("NpcBot (.npcbot)")
        nbBtn:SetPoint("LEFT", pbBtn, "RIGHT", 8, 0)
        nbBtn:SetScript("OnClick", function() selectSub(2) end)

        selectSub(MoP_GM.db.activeBotsSubTab or 1)
    end,
})
