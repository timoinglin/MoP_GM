-- MoP_GM/UI/MainFrame.lua
-- Movable parent window with header, tab strip, scrolling content, and footer.

local FRAME_W, FRAME_H = 900, 540
local HEADER_H = 26
local FOOTER_H = 38
local TAB_AREA_H = 32

MoP_GM.tabs = {}      -- array of { id, label, builder, contentFrame }

local function buildTabStrip(parent)
    local strip = CreateFrame("Frame", nil, parent)
    strip:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, -HEADER_H - 4)
    strip:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -8, -HEADER_H - 4)
    strip:SetHeight(TAB_AREA_H)
    return strip
end

local function selectTab(index)
    local tabs = MoP_GM.tabs
    if not tabs[index] then return end
    PanelTemplates_SetTab(MoP_GM_MainFrame, index)
    for i, tab in ipairs(tabs) do
        if tab.contentFrame then
            if i == index then tab.contentFrame:Show() else tab.contentFrame:Hide() end
        end
    end
    if tabs[index].onShow then tabs[index].onShow() end
    MoP_GM.db.activeTab = index
end
MoP_GM.SelectTab = selectTab

function MoP_GM.RegisterTab(def)
    -- def = { id, label, builder = function(parent) end, onShow = function() end }
    table.insert(MoP_GM.tabs, def)
end

local function buildAllTabs()
    local main = MoP_GM_MainFrame
    local strip = main.tabStrip

    -- Create tab buttons + content frames.
    for i, tab in ipairs(MoP_GM.tabs) do
        local btn = CreateFrame("Button", "MoP_GM_MainFrameTab" .. i, main, "PanelTabButtonTemplate")
        btn:SetText(tab.label)
        btn:SetID(i)
        if i == 1 then
            btn:SetPoint("BOTTOMLEFT", strip, "BOTTOMLEFT", 4, 0)
        else
            btn:SetPoint("LEFT", _G["MoP_GM_MainFrameTab" .. (i - 1)], "RIGHT", -14, 0)
        end
        btn:SetScript("OnClick", function(self)
            PlaySound and PlaySound("UChatScrollButton")
            selectTab(self:GetID())
        end)
        PanelTemplates_TabResize(btn, 0)

        local content = CreateFrame("Frame", nil, main)
        content:SetPoint("TOPLEFT", main, "TOPLEFT", 8, -HEADER_H - TAB_AREA_H - 8)
        content:SetPoint("BOTTOMRIGHT", main, "BOTTOMRIGHT", -8, FOOTER_H + 4)
        MoP_GM.ApplyBackdrop(content, "inset", 0.6)
        content:Hide()
        tab.contentFrame = content

        if tab.builder then tab.builder(content) end
    end
    PanelTemplates_SetNumTabs(main, #MoP_GM.tabs)
    selectTab(MoP_GM.db.activeTab or 1)
end

function MoP_GM.RestoreMainFramePosition()
    local f = MoP_GM_MainFrame
    if not f then return end
    MoP_GM.RestoreFramePoint(f, "frame", MoP_GM.defaults.frame)
end

local function createMainFrame()
    local f = CreateFrame("Frame", "MoP_GM_MainFrame", UIParent)
    f:SetSize(FRAME_W, FRAME_H)
    f:SetFrameStrata("HIGH")
    f:SetToplevel(true)
    f:SetMovable(true)
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self) self:StartMoving() end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        MoP_GM.SaveFramePoint(self, "frame")
    end)
    f:SetScript("OnShow", function() if MoP_GM.db and MoP_GM.db.frame then MoP_GM.db.frame.shown = true end end)
    f:SetScript("OnHide", function() if MoP_GM.db and MoP_GM.db.frame then MoP_GM.db.frame.shown = false end end)
    MoP_GM.ApplyBackdrop(f, "panel", 0.92)

    -- Header
    local header = CreateFrame("Frame", nil, f)
    header:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -4)
    header:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
    header:SetHeight(HEADER_H)
    f.header = header

    local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", header, "LEFT", 8, 0)
    title:SetText(MoP_GM.colors.accent .. "MoP_GM" .. MoP_GM.colors.reset .. "  |cffaaaaaav" .. MoP_GM.version .. "|r")

    local close = CreateFrame("Button", nil, header, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", header, "TOPRIGHT", 4, 4)
    close:SetScript("OnClick", function() f:Hide() end)

    -- Tab strip placeholder; tabs registered by tab files, built in OnLogin.
    f.tabStrip = buildTabStrip(f)

    -- Footer free-text command bar
    local footer = MoP_GM.CreateFreeTextBar(f)
    footer:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 4, 4)
    footer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
    f.footer = footer

    f:Hide()
    return f
end

-- Wire up via the OnLogin hook (after all tab files have called RegisterTab).
local prevOnLogin = MoP_GM.OnLogin
function MoP_GM.OnLogin()
    if prevOnLogin then prevOnLogin() end
    if not MoP_GM_MainFrame then createMainFrame() end
    MoP_GM.RestoreMainFramePosition()
    buildAllTabs()
    if MoP_GM.db.frame and MoP_GM.db.frame.shown then
        MoP_GM_MainFrame:Show()
    end
end

-- Create the frame shell early so tabs can refer to it during their builders.
createMainFrame()
