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

