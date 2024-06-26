local M = {}
local api = vim.api
local Config = require("screenkey.config")

---@param t table Table to check
---@param value any Value to compare or predicate function reference
---@return boolean `true` if `t` contains `value`
M.tbl_contains = function(t, value)
    for _, v in pairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

---@param key string
---@return string[] split
function M.split_key(key)
    local split = {}
    local tmp = ""
    local diamond_open = false
    for i = 1, #key do
        local curr_char = key:sub(i, i)
        tmp = tmp .. curr_char
        if curr_char == "<" then
            diamond_open = true
        elseif curr_char == ">" then
            diamond_open = false
        end
        if not diamond_open then
            table.insert(split, tmp)
            tmp = ""
        end
    end
    return split
end

function M.should_disable()
    local filetype = api.nvim_get_option_value("filetype", { buf = 0 })
    if M.tbl_contains(Config.options.disable.filetypes, filetype) then
        return true
    end

    local buftype = api.nvim_get_option_value("buftype", { buf = 0 })
    if M.tbl_contains(Config.options.disable.buftypes, buftype) then
        return true
    end

    return false
end

---@param key string
---@return boolean
function M.is_mapping(key)
    local mode = api.nvim_get_mode()
    local mappings = api.nvim_get_keymap(mode.mode)
    for _, mapping in ipairs(mappings) do
        if
            ---@diagnostic disable-next-line: undefined-field
            key:upper() == mapping.lhs:upper()
            ---@diagnostic disable-next-line: undefined-field
            or key:upper() == vim.fn.keytrans(mapping.lhs):upper()
        then
            return true
        end
    end

    return false
end

return M
