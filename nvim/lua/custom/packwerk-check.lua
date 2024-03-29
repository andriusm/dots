function PackwerkCheck()
    local ns_id = vim.api.nvim_create_namespace('my_plugin_annotation')
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

    local output = vim.fn.systemlist({ "/Users/andrius/.cargo/bin/pks", "check" })
    -- if vim.v.shell_error ~= 0 then
    --     print("Error running packwerk check")
    --     return
    -- end

    local line = output[1]
    if line == "No violations detected!" then
        print("Packwerk check passed")
        return
    end

    local msg = "  🔥 " .. output[2]
    local parts = vim.split(line, ":")
    local filepath = parts[1]
    local line_number = tonumber(parts[2])

    vim.cmd('e ' .. filepath)
    vim.api.nvim_win_set_cursor(0, { line_number, 0 })
    vim.cmd('normal! zz')

    vim.api.nvim_buf_set_virtual_text(0, ns_id, line_number - 1, { { msg, "Error" } }, {})
end

vim.keymap.set("n", "<leader>z", "<cmd>lua PackwerkCheck()<CR>")

