local M = {}

M.defaults = {
    win_opts = {
        relative = "editor",
        anchor = "SE",
        row_adjustment = -1,
        width = 40,
        height = 3,
        border = "single",
    },
    compress_after = 3,
    clear_after = 3,
    disable = {
        filetypes = {},
        buftypes = {},
    },
    show_leader = false,
    group_mappings = false,
}

M.options = {}

---@param opts? table
function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
