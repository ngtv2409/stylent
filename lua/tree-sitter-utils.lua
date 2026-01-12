local M = {}
M.db = {}

local ts =  vim.treesitter

-- Get comments in the current buffer as ts nodes
function M.get_comments()
    local parser = ts.get_parser(0)
    local tree = parser:parse()[1]
    local root = tree:root()
    local lang = parser:lang()

    local query = ts.query.parse(
        lang,
        [[(comment) @comment]]
    )
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
                node = node  -- keep the original Tree-sitter node for advanced use
            })
        end
    end
    return comments
end

M.db.debug_comment = function (comment)
    print("Comment:", comment.text)
    print("Type:", comment.type)
    print("Start:", comment.start_row, comment.start_col)
    print("End:", comment.end_row, comment.end_col)
end

M.db.debug_comments = function (comments)
    for _, comment in ipairs(comments) do
        M.db.debug_comment(comment)
        print("---")  -- separator between comments
    end
end

return M
