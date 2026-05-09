-- MoP_GM/Core/CommandRunner.lua
-- Single chokepoint for sending dot-commands to the server.

-- Send a dot-command to the server. Trinity-derived cores (Emucoach included)
-- intercept dot-prefixed messages on the server side before they're broadcast
-- as normal chat, so SendChatMessage("SAY") delivers the command silently —
-- no public SAY appears in chat, only the server's response to the command.
function MoP_GM._ExecuteRaw(line)
    if MoP_GM.IsBlank(line) then return end
    SendChatMessage(line, "SAY")
    MoP_GM.PushHistory(line)
end

-- Public entry point. opts.danger=true pops a confirm dialog first.
function MoP_GM.RunCommand(line, opts)
    if MoP_GM.IsBlank(line) then return end
    if opts and opts.danger then
        local dialog = StaticPopup_Show("MOPGM_CONFIRM_CMD", line)
        if dialog then dialog.data = line end
        return
    end
    MoP_GM._ExecuteRaw(line)
end

-- Build command string from a definition + a table of arg values keyed by arg.key.
-- Returns the string, or (nil, errorMessage) if a required arg is missing/invalid.
function MoP_GM.BuildLine(def, values)
    if not def or not def.format then return nil, "no command" end
    local args = def.args or {}
    if #args == 0 then return def.format end
    local resolved = {}
    for i, arg in ipairs(args) do
        local raw = values and values[arg.key]
        local v = MoP_GM.ResolveArg(raw, arg)
        if MoP_GM.IsBlank(v) then
            if arg.optional then
                v = arg.default or ""
            else
                return nil, "missing: " .. (arg.placeholder or arg.key)
            end
        end
        if arg.numeric then
            local n = tonumber(v)
            if not n then return nil, (arg.placeholder or arg.key) .. " must be numeric" end
            v = tostring(n)
        end
        resolved[i] = v
    end
    -- Strip trailing optional placeholders that are blank to keep the line tidy.
    while #resolved > 0 and resolved[#resolved] == "" do
        resolved[#resolved] = nil
    end
    -- string.format requires the right number of placeholders; if we trimmed
    -- trailing optional values, fall back to a manual concat after the prefix.
    local placeholderCount = 0
    for _ in def.format:gmatch("%%s") do placeholderCount = placeholderCount + 1 end
    if #resolved == placeholderCount then
        return string.format(def.format, unpack(resolved))
    else
        -- pad with empty strings, then trim trailing whitespace
        local padded = {}
        for i = 1, placeholderCount do padded[i] = resolved[i] or "" end
        local line = string.format(def.format, unpack(padded))
        return (line:gsub("%s+$", ""))
    end
end
