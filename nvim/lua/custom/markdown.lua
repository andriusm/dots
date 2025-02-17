local M = {}

function M.follow_link()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))

    local line = vim.api.nvim_get_current_line()

    local left_bracket = col
    while left_bracket > 0 do
        if line:sub(left_bracket, left_bracket) == '[' then
            break
        end
        left_bracket = left_bracket - 1
    end

    if left_bracket < 0 then
        print("No '[' found to the left")
        return
    end

    if left_bracket == 0 then
        left_bracket = 1
    end

    local right_bracket = col + 1
    while right_bracket <= #line do
        if line:sub(right_bracket, right_bracket) == ']' then
            break
        end
        right_bracket = right_bracket + 1
    end

    if not right_bracket then
        print("No ']' found to the right")
        return
    end

    local link = line:sub(left_bracket + 1, right_bracket - 1)
    -- print(link)
    if #link == 0 then
        print("No link found")
        return
    end

    local fullpath = vim.fn.expand("%:p:h") .. "/" .. link .. ".md"

    vim.cmd("edit " .. fullpath)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.keymap.set('n', '<leader>xf', M.follow_link)
    end
})

return M
