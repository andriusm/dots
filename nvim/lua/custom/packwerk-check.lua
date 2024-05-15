function PackwerkCheck()
    local ns_id = vim.api.nvim_create_namespace('my_plugin_annotation')
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

    local output = vim.fn.systemlist({ "/Users/andrius/.cargo/bin/pks", "check" })

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

    local opts = {
        virt_text = { { msg, "Error" } },
        virt_text_pos = "eol",
    }
    vim.api.nvim_buf_set_extmark(0, ns_id, line_number - 1, 0, opts)
end

vim.keymap.set("n", "<leader>xp", "<cmd>lua PackwerkCheck()<CR>")

