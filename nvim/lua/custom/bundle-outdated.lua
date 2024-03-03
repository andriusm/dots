function BundleOutdated()
    local filename = vim.fn.expand('%:t')
    if filename ~= "Gemfile" then
        print("Not a Gemfile")
        return
    end

    vim.cmd [[highlight MyErrorHighlight guifg=#e67e80 guibg=#3b3f4c]]

    local outdated = {}
    local ns_id = vim.api.nvim_create_namespace('my_plugin_annotation2')
    local bufnr = vim.api.nvim_get_current_buf()

    local display_stuff = function()
        local line_num = 0
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

        for _, line in ipairs(lines) do
            local gem = line:match("^gem%s*'(%S*)'")

            if gem then
                if outdated[gem] ~= nil then
                    local msg = " 💎 " .. outdated[gem]
                    vim.api.nvim_buf_set_virtual_text(bufnr, ns_id, line_num, { { msg, "MyErrorHighlight" } }, {})
                end
            end

            line_num = line_num + 1
        end
    end

    local on_exit = function(obj)
        local found = false

        -- for line in string.gmatch(obj.stdout, "([^\n]*)\n?") do
        for line in string.gmatch(obj, "([^\n]*)\n?") do
            if line ~= "" then
                if found then
                    local key = line:match("^[^%s]*")
                    local part2, part3 = line:match("^%S+%s*(%S*)%s*(%S*)")
                    local value = "Current: " .. part2 .. " Latest: " .. part3

                    outdated[key] = value
                elseif line:sub(1, 3) == "Gem" then
                    found = true
                end
            end
        end

        vim.defer_fn(display_stuff, 0)
    end

    print("running bundle outdated")
    -- vim.system({ 'bundle', 'outdated', '--strict' }, { detach = true, timeout = -1, text = true }, on_exit)
    local res = vim.fn.system({ 'bundle', 'outdated', '--strict' })
    -- print(res)
    on_exit(res)
end

vim.keymap.set("n", "<leader>x", "<cmd>lua BundleOutdated()<CR>")

