-- MoP_GM/UI/Tabs/Teleport.lua
-- Two sub-tabs:
--   1. Commands  — free-form .tele/.go entries + save/delete row.
--   2. Locations — clickable grid of seeded MoP locations + user-saved entries.

local TELE_BTN_W = 200
local TELE_BTN_H = 22
local TELE_COLS  = 4

local function buildCommandsPanel(parent)
    -- Free-form .tele / .go commands at the top.
    MoP_GM.LayoutRows(parent, MoP_GM.Commands.TeleCommands)

    -- Save / delete a teleport name row (anchored to the bottom).
    local saveRow = CreateFrame("Frame", nil, parent)
    saveRow:SetHeight(28)
    saveRow:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 8, 6)
    saveRow:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -8, 6)

    local label = saveRow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    label:SetPoint("LEFT", saveRow, "LEFT", 0, 0)
    label:SetText("Save current spot as:")

    local edit = CreateFrame("EditBox", nil, saveRow)
    edit:SetSize(160, 22)
    edit:SetPoint("LEFT", label, "RIGHT", 8, 0)
    edit:SetFontObject(GameFontHighlightSmall)
    edit:SetTextInsets(6, 6, 0, 0)
    edit:SetAutoFocus(false)
    edit:SetMaxLetters(64)
    local bg = edit:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(edit)
    bg:SetTexture(0, 0, 0, 0.55)

    local addBtn = MoP_GM.MakeFlatButton(saveRow, 90, 22, ".tele add", false)
    addBtn:SetPoint("LEFT", edit, "RIGHT", 8, 0)
    addBtn:SetScript("OnClick", function()
        local n = MoP_GM.Trim(edit:GetText() or "")
        if n == "" then MoP_GM.Print("enter a name first"); return end
        MoP_GM._ExecuteRaw(".tele add " .. n)
        MoP_GM.db.userTeleports = MoP_GM.db.userTeleports or {}
        table.insert(MoP_GM.db.userTeleports, { name = n, label = n })
    end)

    local delBtn = MoP_GM.MakeFlatButton(saveRow, 90, 22, ".tele del", true)
    delBtn:SetPoint("LEFT", addBtn, "RIGHT", 4, 0)
    delBtn:SetScript("OnClick", function()
        local n = MoP_GM.Trim(edit:GetText() or "")
        if n == "" then MoP_GM.Print("enter a name first"); return end
        MoP_GM._ExecuteRaw(".tele del " .. n)
        local list = MoP_GM.db.userTeleports or {}
        for i = #list, 1, -1 do
            if list[i].name == n then table.remove(list, i) end
        end
    end)
end

local function buildLocationsPanel(parent)
    -- Merge seed + user-saved teleport names, dedupe by name, sort by label.
    local merged, seen = {}, {}
    for _, t in ipairs(MoP_GM.SeedTeleports or {}) do
        if not seen[t.name] then table.insert(merged, t); seen[t.name] = true end
    end
    MoP_GM.db.userTeleports = MoP_GM.db.userTeleports or {}
    for _, t in ipairs(MoP_GM.db.userTeleports) do
        if not seen[t.name] then table.insert(merged, t); seen[t.name] = true end
    end
    table.sort(merged, function(a, b) return (a.label or a.name) < (b.label or b.name) end)

    local x0, y0 = 8, -8
    for i, t in ipairs(merged) do
        local col = (i - 1) % TELE_COLS
        local row = math.floor((i - 1) / TELE_COLS)
        local btn = MoP_GM.MakeFlatButton(parent, TELE_BTN_W, TELE_BTN_H, t.label or t.name, false)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x0 + col * (TELE_BTN_W + 4), y0 - row * (TELE_BTN_H + 4))
        btn:SetScript("OnClick", function() MoP_GM._ExecuteRaw(".tele " .. t.name) end)
    end
end

MoP_GM.RegisterTab({
    id = "teleport", label = "Teleport",
    builder = function(parent)
        MoP_GM.BuildSubTabs(parent, {
            { label = "Commands",  builder = buildCommandsPanel  },
            { label = "Locations", builder = buildLocationsPanel },
        }, "subTab_teleport")
    end,
})
