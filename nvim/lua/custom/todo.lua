local M = {}

function M.check_todo_item()
    -- local line_num = vim.api.nvim_win_get_cursor(0)[1]

    local line = vim.api.nvim_get_current_line()

    if line:sub(1, 1) == "-" then
        line = "+" .. line:sub(2)
    elseif line:sub(1, 1) == "+" then
        line = "-" .. line:sub(2)
    end

    vim.api.nvim_set_current_line(line)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "todo",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<F2>', ":lua require('custom.todo').check_todo_item()<CR>", {noremap = true, silent = true})
    end
})

return M
