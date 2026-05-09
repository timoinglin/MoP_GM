-- MoP_GM/Core/Init.lua
-- Addon namespace, defaults, ADDON_LOADED, slash commands.

local addonName = ...
MoP_GM = MoP_GM or {}
MoP_GM.name = "MoP_GM"
MoP_GM.version = "1.0.0"

MoP_GM.defaults = {
    frame = { point = "CENTER", relPoint = "CENTER", x = 0, y = 0, shown = false },
    button = { point = "TOPRIGHT", relPoint = "TOPRIGHT", x = -32, y = -32 },
    favorites = {},
    history = {},
    inputs = {},
    activeTab = 1,
    activeBotsSubTab = 1,
}

local function copyDefaults(src, dst)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then dst[k] = {} end
            copyDefaults(v, dst[k])
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
    return dst
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, name)
    if event == "ADDON_LOADED" and name == addonName then
        MoP_GM_DB = MoP_GM_DB or {}
        copyDefaults(MoP_GM.defaults, MoP_GM_DB)
        MoP_GM.db = MoP_GM_DB
    elseif event == "PLAYER_LOGIN" then
        if MoP_GM.OnLogin then MoP_GM.OnLogin() end
    end
end)

-- Slash commands
SLASH_MOPGM1 = "/mopgm"
SLASH_MOPGM2 = "/gm"
SlashCmdList["MOPGM"] = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "reset" then
        MoP_GM.db.frame = nil
        MoP_GM.db.button = nil
        copyDefaults(MoP_GM.defaults, MoP_GM.db)
        if MoP_GM.RestoreMainFramePosition then MoP_GM.RestoreMainFramePosition() end
        if MoP_GM.RestoreButtonPosition then MoP_GM.RestoreButtonPosition() end
        DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99MoP_GM|r: positions reset.")
    elseif msg == "show" then
        if MoP_GM_MainFrame then MoP_GM_MainFrame:Show() end
    elseif msg == "hide" then
        if MoP_GM_MainFrame then MoP_GM_MainFrame:Hide() end
    else
        if MoP_GM_MainFrame then
            if MoP_GM_MainFrame:IsShown() then MoP_GM_MainFrame:Hide() else MoP_GM_MainFrame:Show() end
        end
    end
end
