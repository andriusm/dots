function FindFileOwner()
    local filename = vim.fn.expand('%')
    local output = vim.fn.systemlist({ "codeowners", filename })

    local line = output[1]
    local parts = vim.split(line, "@")
    local filepath = string.gsub(parts[1], "%s+", "")
    local owners = {}

    for i = 2, #parts do
        owners[#owners + 1] = parts[i]
    end

    local public = filepath:find("public") ~= nil and "Yes" or "No" 
    local modal_content = { "File: " .. filepath, "Public:" .. public, "Owners: " .. owners[1] }

    for i, owner in ipairs(owners) do
        if i ~= 1 then
            modal_content[#modal_content + 1] = "        " .. owner
        end
    end

    CreateModalWindow(modal_content)
end

function FileInfo()
    local filename = vim.fn.expand('%')

    local modal_content = { "File: " .. filename }

    CreateModalWindow(modal_content)
end

function RunCurrentLine()
  local current_line = vim.api.nvim_get_current_line()
  -- vim.cmd("!" .. current_line)
  local output = vim.fn.systemlist({ "zsh", "-c", current_line })
  CreateModalWindow(output)
end
