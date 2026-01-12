-- init.lua
local M = {}

local hi = require("stylent.highlight")

local hl = vim.api.nvim_set_hl


-- # Basic builtin markup to use
-- Headings
hl(0, "StylentHeading1", { link = "Title" })
hl(0, "StylentHeading2", { link = "Title" })

-- Text styles
hl(0, "StylentBold", { bold = true })
hl(0, "StylentItalic", { italic = true })
hl(0, "StylentBoldItalic", { bold = true, italic = true })

-- Links and inline code
hl(0, "StylentLink", { link = "Underlined" })
hl(0, "StylentCode", { fg = "#d19a66" })

M.config = {
    patterns = {
        {"%*%*.-%*%*", "StylentBold"}
    }
}

local function has_parser()
    local ok, parser = pcall(vim.treesitter.get_parser, 0)
    return ok and parser ~= nil
end
M.setup = function(config)
    if config then
        M.config = config
    end
    events = { "BufReadPost", "BufWritePost", "TextChanged", "TextChangedI" }
    local group = vim.api.nvim_create_augroup("StylentHighlight", { clear = true })
    for _, event in ipairs(events) do
        vim.api.nvim_create_autocmd(event, {
            group = group,
            pattern = "*",
            callback = function()
                if has_parser() then
                    hi.do_style(M.config.patterns)
                end
            end
        })
    end
end

return M
