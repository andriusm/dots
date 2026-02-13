-- local function file_exists(name)
--     local f = io.open(name, "r")
--     if f ~= nil then
--         io.close(f)
--         return true
--     else return false end
-- end

function AltRubyFile()
    if vim.bo.filetype ~= "ruby" then
        return
    end

    local cfile = vim.fn.expand('%:f')
    local afile = ''

    if string.find(cfile, "^packages/") then
        if string.find(cfile, "_spec.rb$") then
            afile = string.gsub(cfile, "/spec/", "/app/")
            afile = string.gsub(afile, "_spec.rb$", ".rb")
        else
            afile = string.gsub(cfile, "/app/", "/spec/")
            afile = string.gsub(afile, ".rb$", "_spec.rb")
        end
    elseif string.find(cfile, "^lib/") or string.find(cfile, "^spec/lib/") then
        if string.find(cfile, "_spec.rb$") then
            afile = string.gsub(cfile, "^spec/", "")
            afile = string.gsub(afile, "_spec.rb$", ".rb")
        else
            afile = string.gsub(cfile, "^lib/", "spec/lib/")
            afile = string.gsub(afile, ".rb$", "_spec.rb")
        end
    else
        if string.find(cfile, "_spec.rb$") then
            afile = string.gsub(cfile, "^spec/", "app/")
            afile = string.gsub(afile, "_spec.rb$", ".rb")
        else
            afile = string.gsub(cfile, "^app/", "spec/")
            afile = string.gsub(afile, ".rb$", "_spec.rb")
        end
    end

    local adir = vim.fn.fnamemodify(afile, ':h')

    if vim.fn.isdirectory(adir) == 0 then
        vim.fn.mkdir(adir, 'p')
    end

    vim.cmd(":edit " .. afile)
end

function PackwerkPackageFile()
    if vim.bo.filetype ~= "ruby" then
        return
    end

    local cfile = vim.fn.expand('%:f')

    if string.find(cfile, "^packages/") then
        local parts = vim.split(cfile, "/")
        local pfile = parts[1] .. "/" .. parts[2] .. "/package.yml"
        vim.cmd(":edit " .. pfile)
    end
end

function BundleInstall()
    print("Running bundle install...")

    vim.fn.systemlist({ "bundle", "install" })

    if vim.v.shell_error == 0 then
        print("Bundle install successful")
    else
        print("Bundle install failed")
    end
end

function DbMigrate()
    print("Running migrations...")

    vim.fn.systemlist({ "bundle", "exec", "rake", "db:migrate" })

    if vim.v.shell_error == 0 then
        print("Migration successful")
    else
        print("Migration failed")
    end
end

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
                    -- vim.api.nvim_buf_set_virtual_text(bufnr, ns_id, line_num, { { msg, "MyErrorHighlight" } }, {})

            local opts = {
                        virt_text = { { msg, "Error" } },
                        virt_text_pos = "eol",
                    }
                    vim.api.nvim_buf_set_extmark(bufnr, ns_id, line_num, 1, {virt_text = { { msg, "Error" } }})
                end
            end

            line_num = line_num + 1
        end
    end

    local on_exit = function(obj)
        local found = false

        for line in string.gmatch(obj.stdout, "([^\n]*)\n?") do
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

    print("running bundle outdated (async)")
    vim.system({ 'bundle', 'outdated', '--strict' }, { text = true }, function(result)
        vim.schedule(function()
            on_exit(result)
        end)
    end)
end
