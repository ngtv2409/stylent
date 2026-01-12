local M = {}

-- I don't know how to name this
-- Match the patterns and apply styling on the current buffer
-- patterns: (string, highlight group)
function M.do_style(patterns)
    local st = require("stylent")

    local bufnr = 0
    -- Create a namespace if it doesn't exist yet
    M.ns = M.ns or vim.api.nvim_create_namespace("StylentHighlight")
    -- Clear previous highlights in this buffer for our namespace
    vim.api.nvim_buf_clear_namespace(bufnr, M.ns, 0, -1)

    local cs = st._tsutils.get_comments()

    for i = 1, #cs do
        local c = cs[i]

        for _, p in ipairs(patterns) do
            local pattern, hl_group = p[1], p[2]
            local matches = st._match.match_one(pattern, c.text)

            for j = 1, #matches do
                local m = matches[j]
                local lines = vim.split(m.match, "\n", true)

                for l, text in ipairs(lines) do
                    local row = c.start_row + l - 1
                    local col_s = l == 1 and m.s_idx - 1 + c.start_col or 0
                    local col_e = l == #lines and m.e_idx + c.start_col or #text
                    vim.api.nvim_buf_add_highlight(bufnr, M.ns, hl_group, row, col_s, col_e)
                end
            end
        end
    end
end

return M
