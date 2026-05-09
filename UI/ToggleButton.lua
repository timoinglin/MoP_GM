-- MoP_GM/UI/ToggleButton.lua
-- Minimap-anchored launcher button. Click → toggle MainFrame.
-- SHIFT+click and drag → reposition; position persisted in MoP_GM_DB.button.

local SIZE = 32

local function createToggleButton()
    local b = CreateFrame("Button", "MoP_GM_ToggleButton", UIParent)
    b:SetSize(SIZE, SIZE)
    b:SetFrameStrata("MEDIUM")
    b:SetMovable(true)
    b:SetClampedToScreen(true)
    b:EnableMouse(true)
    b:RegisterForClicks("AnyUp")

    -- Icon (use a dependable Blizzard icon path; falls back gracefully).
    local icon = b:CreateTexture(nil, "BACKGROUND")
    icon:SetTexture("Interface\\Icons\\INV_Misc_Gear_03")
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    icon:SetPoint("TOPLEFT", b, "TOPLEFT", 3, -3)
    icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -3, 3)

    -- Border ring like a Blizzard minimap button.
    local border = b:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(54, 54)
    border:SetPoint("CENTER", b, "CENTER", 11, -11)

    b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

    -- Drag only while SHIFT is held.
    b:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and IsShiftKeyDown() then
            self:StartMoving()
            self.isMoving = true
        end
    end)
    b:SetScript("OnMouseUp", function(self)
        if self.isMoving then
            self:StopMovingOrSizing()
            self.isMoving = false
            MoP_GM.SaveFramePoint(self, "button")
        end
    end)

    b:SetScript("OnClick", function(self, button)
        if self.isMoving then return end
        if IsShiftKeyDown() then return end -- shift used for drag, ignore click
        if button == "LeftButton" then
            local f = MoP_GM_MainFrame
            if not f then return end
            if f:IsShown() then f:Hide() else f:Show() end
        elseif button == "RightButton" then
            -- Right-click also works as a quick toggle.
            local f = MoP_GM_MainFrame
            if not f then return end
            if f:IsShown() then f:Hide() else f:Show() end
        end
    end)

    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("MoP_GM", 0.2, 1, 0.6)
        GameTooltip:AddLine("Click to toggle the GM panel.", 1, 1, 1)
        GameTooltip:AddLine("SHIFT-drag to reposition this button.", 0.7, 0.7, 0.7)
        GameTooltip:AddLine("/mopgm reset to recenter everything.", 0.5, 0.5, 0.5)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)

    return b
end

function MoP_GM.RestoreButtonPosition()
    local b = MoP_GM_ToggleButton
    if not b then return end
    MoP_GM.RestoreFramePoint(b, "button", MoP_GM.defaults.button)
end

local prevOnLogin = MoP_GM.OnLogin
function MoP_GM.OnLogin()
    if prevOnLogin then prevOnLogin() end
    if not MoP_GM_ToggleButton then createToggleButton() end
    MoP_GM.RestoreButtonPosition()
end
