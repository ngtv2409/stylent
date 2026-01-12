local M = {}
local ts = vim.treesitter

function M.get_comments()
    local ok, parser = pcall(ts.get_parser, 0)
    if not ok or not parser then
        return {} -- no parser, return empty
    end

    local tree_ok, tree = pcall(function() return parser:parse()[1] end)
    if not tree_ok or not tree then
        return {} -- parse failed
    end

    local root = tree:root()
    local lang = parser:lang()

    local query
    local query_ok, q = pcall(ts.query.parse, lang, [[(comment) @comment]])
    if query_ok then
        query = q
    else
        return {} -- query failed, no comments
    end

    local comments = {}
    for id, node in query:iter_captures(root, 0) do
        local capture_name = query.captures[id]
        if capture_name == "comment" then
            local start_row, start_col, end_row, end_col = node:range()
            table.insert(comments, {
                text = ts.get_node_text(node, 0),
                type = node:type(),
                start_row = start_row,
                start_col = start_col,
                end_row = end_row,
                end_col = end_col,
                node = node
            })
        end
    end

    return comments
end

return M
