-- MoP_GM/UI/Tabs/Teleport.lua
-- Two sections: free-form .tele/.go, plus a clickable list of seeded + saved
-- teleport names that send `.tele <name>`.

local TELE_BTN_W = 200
local TELE_BTN_H = 22

local function buildTeleportList(parent, yStart)
    local hdr = MoP_GM.CreateSectionHeader(parent, "Saved teleport names")
    hdr:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, yStart)
    local y = yStart - hdr:GetHeight() - 6

    -- Merge seeded and user-added unique by name.
    local merged, seen = {}, {}
    for _, t in ipairs(MoP_GM.SeedTeleports or {}) do
        if not seen[t.name] then
            table.insert(merged, t); seen[t.name] = true
        end
    end
    MoP_GM.db.userTeleports = MoP_GM.db.userTeleports or {}
    for _, t in ipairs(MoP_GM.db.userTeleports) do
        if not seen[t.name] then
            table.insert(merged, t); seen[t.name] = true
        end
    end
    table.sort(merged, function(a, b) return (a.label or a.name) < (b.label or b.name) end)

    local col, row = 0, 0
    for _, t in ipairs(merged) do
        local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
        btn:SetSize(TELE_BTN_W, TELE_BTN_H)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 8 + col * (TELE_BTN_W + 6), y - row * (TELE_BTN_H + 4))
        btn:SetText(t.label or t.name)
        btn:SetScript("OnClick", function() MoP_GM._ExecuteRaw(".tele " .. t.name) end)
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(t.label or t.name, 1, 0.82, 0)
            GameTooltip:AddLine(".tele " .. t.name, 0.4, 1, 0.4)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        col = col + 1
        if col >= 3 then col = 0; row = row + 1 end
    end
    local rowsUsed = row + (col > 0 and 1 or 0)
    return rowsUsed * (TELE_BTN_H + 4) + (-(yStart) + 8) + hdr:GetHeight() + 6
end

local function buildAddSavedRow(parent, yStart)
    -- Adds .tele add <name> for the current spot, .tele del <name>.
    local hdr = MoP_GM.CreateSectionHeader(parent, "Save / delete a teleport")
    hdr:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, yStart)
    local y = yStart - hdr:GetHeight() - 6

    local edit = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    edit:SetSize(160, 22)
    edit:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, y)
    edit:SetAutoFocus(false)

    local hint = edit:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("LEFT", edit, "LEFT", 4, 0)
    hint:SetText("name")
    edit:HookScript("OnTextChanged", function(self) if self:GetText() == "" then hint:Show() else hint:Hide() end end)

    local addBtn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    addBtn:SetSize(120, 22)
    addBtn:SetPoint("LEFT", edit, "RIGHT", 12, 0)
    addBtn:SetText(".tele add")
    addBtn:SetScript("OnClick", function()
        local n = MoP_GM.Trim(edit:GetText() or "")
        if n == "" then MoP_GM.Print("enter a name first"); return end
        MoP_GM._ExecuteRaw(".tele add " .. n)
        table.insert(MoP_GM.db.userTeleports, { name = n, label = n })
    end)

    local delBtn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    delBtn:SetSize(120, 22)
    delBtn:SetPoint("LEFT", addBtn, "RIGHT", 6, 0)
    delBtn:SetText(".tele del")
    delBtn:SetScript("OnClick", function()
        local n = MoP_GM.Trim(edit:GetText() or "")
        if n == "" then MoP_GM.Print("enter a name first"); return end
        MoP_GM._ExecuteRaw(".tele del " .. n)
        for i = #MoP_GM.db.userTeleports, 1, -1 do
            if MoP_GM.db.userTeleports[i].name == n then
                table.remove(MoP_GM.db.userTeleports, i)
            end
        end
    end)

    return -(y) + 8 + 24
end

MoP_GM.RegisterTab({
    id = "teleport", label = "Teleport",
    builder = function(parent)
        local scroll, content = MoP_GM.CreateScrollContent(parent)

        -- Free-form teleport commands at the top.
        local TeleportCmds = {
            { id="tele",    label="tele",         format=".tele %s",        args={{key="name",placeholder="name"}}, group="Teleport", tooltip="Teleport to a saved name." },
            { id="goxyz",   label="go xyz",       format=".go xyz %s %s %s %s",args={{key="x",placeholder="x",numeric=true},{key="y",placeholder="y",numeric=true},{key="z",placeholder="z",numeric=true},{key="map",placeholder="map",numeric=true,optional=true}}, group="Teleport" },
            { id="gocrtr",  label="go creature",  format=".go creature id %s",args={{key="entry",placeholder="creatureId",numeric=true}}, group="Teleport" },
            { id="goobj",   label="go gobject",   format=".go gobject id %s",args={{key="entry",placeholder="objectId",numeric=true}}, group="Teleport" },
            { id="gograve", label="go graveyard", format=".go graveyard %s", args={{key="id",placeholder="graveyardId",numeric=true}}, group="Teleport" },
            { id="goquest", label="go quest",     format=".go quest %s",     args={{key="id",placeholder="questId",numeric=true}}, group="Teleport" },
            { id="start",   label="start",        format=".start", group="Teleport", tooltip="Teleport to starting location." },
            { id="recallme",label="recall",       format=".recall", group="Teleport" },
            { id="wport",   label="worldport",    format=".worldport %s %s %s %s",args={{key="map",placeholder="map",numeric=true},{key="x",placeholder="x",numeric=true},{key="y",placeholder="y",numeric=true},{key="z",placeholder="z",numeric=true}}, group="Teleport" },
            { id="appearx", label="appear",       format=".appear %s",       args={{key="name",placeholder="player",fallback="target"}}, group="Teleport" },
            { id="summonx", label="summon",       format=".summon %s",       args={{key="name",placeholder="player",fallback="target"}}, group="Teleport" },
        }
        local h1 = MoP_GM.LayoutRows(content, TeleportCmds, { sectionTitle = "Free-form teleport / go" })

        local saveSecH = buildAddSavedRow(content, -h1 - 8)
        local listH = buildTeleportList(content, -h1 - 8 - saveSecH - 16)

        content:SetHeight(math.max(h1 + saveSecH + listH + 60, 400))
    end,
})
