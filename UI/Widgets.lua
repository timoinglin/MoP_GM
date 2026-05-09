-- MoP_GM/UI/Widgets.lua
-- Reusable UI factories used by every tab.

local ROW_HEIGHT   = 24
local ROW_SPACING  = 4
local LABEL_WIDTH  = 150
local INPUT_WIDTH  = 90
local RUN_WIDTH    = 50

-- ─── Backdrops ─────────────────────────────────────────────────────────────
MoP_GM.backdrops = {
    panel = {
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    },
    inset = {
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    },
}

function MoP_GM.ApplyBackdrop(frame, kind, bgAlpha)
    frame:SetBackdrop(MoP_GM.backdrops[kind or "panel"])
    frame:SetBackdropColor(0, 0, 0, bgAlpha or 0.85)
    frame:SetBackdropBorderColor(0.6, 0.6, 0.7, 1)
end

-- ─── Section header ────────────────────────────────────────────────────────
function MoP_GM.CreateSectionHeader(parent, text)
    local header = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    header:SetText(MoP_GM.colors.label .. text .. MoP_GM.colors.reset)
    return header
end

-- ─── Tooltip helpers ───────────────────────────────────────────────────────
local function previewLine(def, getValues)
    local values = getValues and getValues() or {}
    local line, err = MoP_GM.BuildLine(def, values)
    if line then return line end
    return def.format .. (err and ("  |cffaaaaaa(" .. err .. ")|r") or "")
end

function MoP_GM.AttachTooltip(widget, def, getValues)
    widget:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(def.label or def.id or "(command)", 1, 0.82, 0)
        if def.tooltip then
            GameTooltip:AddLine(def.tooltip, 1, 1, 1, true)
        end
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(previewLine(def, getValues), 0.4, 1, 0.4, true)
        if def.danger then
            GameTooltip:AddLine("Destructive — confirmation required.", 1, 0.3, 0.3)
        end
        GameTooltip:AddLine("Right-click: " .. (MoP_GM.IsFavorite(def) and "unpin from Favorites" or "pin to Favorites"), 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end)
    widget:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- ─── Single command row ────────────────────────────────────────────────────
-- def = { id, label, format, args, danger, group, tooltip }
-- Returns the row frame; height = ROW_HEIGHT.
function MoP_GM.CreateCommandRow(parent, def)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW_HEIGHT)
    row.def = def

    local rowKey = (def.group or "?") .. ":" .. (def.id or def.label or "?")

    -- The clickable label-button.
    local btn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    btn:SetSize(LABEL_WIDTH, ROW_HEIGHT - 2)
    btn:SetPoint("LEFT", row, "LEFT", 0, 0)
    btn:SetText(def.label or def.id)
    if def.danger then
        local fs = btn:GetFontString()
        if fs then fs:SetTextColor(1, 0.45, 0.45) end
    end
    row.button = btn
    row:RegisterForClicks("AnyUp")

    -- Build the input boxes for each arg.
    row.edits = {}
    local prev = btn
    for i, arg in ipairs(def.args or {}) do
        local edit = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
        edit:SetSize(INPUT_WIDTH, ROW_HEIGHT - 2)
        edit:SetPoint("LEFT", prev, "RIGHT", 12, 0)
        edit:SetAutoFocus(false)
        edit:SetMaxLetters(arg.numeric and 12 or 64)
        edit:SetNumeric(false) -- we coerce manually so error message can be friendly
        if arg.placeholder then
            -- 5.4.8 has no built-in placeholder; mimic with an OVERLAY string.
            local hint = edit:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            hint:SetPoint("LEFT", edit, "LEFT", 4, 0)
            hint:SetText(arg.placeholder)
            edit.hint = hint
            edit:HookScript("OnTextChanged", function(self)
                if self:GetText() == "" then self.hint:Show() else self.hint:Hide() end
            end)
            edit:HookScript("OnEditFocusGained", function(self) self.hint:Hide() end)
            edit:HookScript("OnEditFocusLost", function(self)
                if self:GetText() == "" then self.hint:Show() end
            end)
        end
        edit:HookScript("OnTextChanged", function(self)
            MoP_GM.SetInputCache(rowKey, arg.key, self:GetText())
        end)
        local cached = MoP_GM.GetInputCache(rowKey, arg.key)
        if cached then edit:SetText(cached) end
        edit.argDef = arg
        row.edits[arg.key] = edit
        prev = edit
    end

    -- Run button at the right edge.
    local run = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    run:SetSize(RUN_WIDTH, ROW_HEIGHT - 2)
    run:SetPoint("LEFT", prev, "RIGHT", 12, 0)
    run:SetText("Run")
    row.run = run

    local function gatherValues()
        local v = {}
        for _, arg in ipairs(def.args or {}) do
            local edit = row.edits[arg.key]
            v[arg.key] = edit and edit:GetText() or nil
        end
        return v
    end

    local function execute()
        local line, err = MoP_GM.BuildLine(def, gatherValues())
        if not line then
            MoP_GM.Print(MoP_GM.colors.warn .. (err or "invalid args") .. MoP_GM.colors.reset)
            return
        end
        MoP_GM.RunCommand(line, { danger = def.danger })
    end

    btn:SetScript("OnClick", function(_, mouseButton)
        if mouseButton == "RightButton" then
            MoP_GM.ToggleFavorite(def)
            return
        end
        execute()
    end)
    run:SetScript("OnClick", execute)

    -- Right-click on the run button or any edit also pins (parity with label).
    run:RegisterForClicks("AnyUp")
    run:HookScript("OnClick", function(_, mb) if mb == "RightButton" then MoP_GM.ToggleFavorite(def) end end)

    MoP_GM.AttachTooltip(btn, def, gatherValues)
    MoP_GM.AttachTooltip(run, def, gatherValues)

    return row
end

-- ─── Layout helper: stack rows vertically inside a parent ─────────────────
-- Returns total height used, so callers can size their scroll-content.
function MoP_GM.LayoutRows(parent, defs, opts)
    opts = opts or {}
    local x = opts.x or 8
    local yTop = opts.yTop or 8
    local sectionTitle = opts.sectionTitle
    local rowsPerColumn = opts.rowsPerColumn -- if set, lay out in columns
    local columnWidth = opts.columnWidth or 520

    local y = -yTop
    if sectionTitle then
        local hdr = MoP_GM.CreateSectionHeader(parent, sectionTitle)
        hdr:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        y = y - hdr:GetHeight() - 6
    end

    local startY = y
    local col = 0
    local rowCount = 0
    for _, def in ipairs(defs) do
        local row = MoP_GM.CreateCommandRow(parent, def)
        row:SetPoint("TOPLEFT", parent, "TOPLEFT", x + col * columnWidth, y)
        row:SetWidth(columnWidth - 16)
        y = y - (ROW_HEIGHT + ROW_SPACING)
        rowCount = rowCount + 1
        if rowsPerColumn and rowCount % rowsPerColumn == 0 then
            col = col + 1
            y = startY
        end
    end

    return -y + 8
end

-- ─── Free-text command box ─────────────────────────────────────────────────
function MoP_GM.CreateFreeTextBar(parent)
    local bar = CreateFrame("Frame", nil, parent)
    bar:SetHeight(28)

    local edit = CreateFrame("EditBox", nil, bar, "InputBoxTemplate")
    edit:SetHeight(22)
    edit:SetPoint("LEFT", bar, "LEFT", 8, 0)
    edit:SetPoint("RIGHT", bar, "RIGHT", -68, 0)
    edit:SetAutoFocus(false)
    edit:SetMaxLetters(255)

    local hint = edit:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    hint:SetPoint("LEFT", edit, "LEFT", 6, 0)
    hint:SetText("Type any .command and press Enter (↑/↓ for history)")
    edit.hint = hint
    edit:HookScript("OnTextChanged", function(self)
        if self:GetText() == "" then self.hint:Show() else self.hint:Hide() end
    end)
    edit:HookScript("OnEditFocusGained", function(self) self.hint:Hide() end)
    edit:HookScript("OnEditFocusLost", function(self) if self:GetText() == "" then self.hint:Show() end end)

    local send = CreateFrame("Button", nil, bar, "UIPanelButtonTemplate")
    send:SetSize(56, 22)
    send:SetPoint("LEFT", edit, "RIGHT", 8, 0)
    send:SetText("Send")

    local historyIndex = 0
    local function submit()
        local text = MoP_GM.Trim(edit:GetText())
        if text == "" then return end
        if not text:match("^[%./]") then text = "." .. text end
        MoP_GM._ExecuteRaw(text)
        edit:SetText("")
        historyIndex = 0
    end
    edit:SetScript("OnEnterPressed", submit)
    send:SetScript("OnClick", submit)
    edit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    edit:SetScript("OnArrowPressed", function(self, key)
        local hist = MoP_GM.GetHistory()
        if not hist or #hist == 0 then return end
        if key == "UP" then
            historyIndex = math.min(historyIndex + 1, #hist)
        elseif key == "DOWN" then
            historyIndex = math.max(historyIndex - 1, 0)
        end
        if historyIndex == 0 then
            self:SetText("")
        else
            self:SetText(hist[historyIndex] or "")
        end
        self:HighlightText(0, 0)
        self:SetCursorPosition(self:GetText():len())
    end)

    bar.edit = edit
    bar.send = send
    return bar
end

-- ─── Generic scroll content holder ────────────────────────────────────────
function MoP_GM.CreateScrollContent(parent)
    local scroll = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -4)
    scroll:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -28, 4)
    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(820, 400)
    scroll:SetScrollChild(content)
    scroll.content = content
    return scroll, content
end
