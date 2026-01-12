-- Match the wrapping patterns ** ... **, [ ... ]
-- For highlight
local M = {}

function M.match_one(pattern, text)
    local start_pos = 1

    local matches = {}

    while true do
        local s_idx, e_idx = text:find(pattern, start_pos)
        if not s_idx then break end
        table.insert(matches, {
            match = text:sub(s_idx, e_idx),
            s_idx = s_idx,
            e_idx = e_idx
        })
        start_pos = e_idx + 1  -- continue after the previous match
    end
    return matches
end

return M
