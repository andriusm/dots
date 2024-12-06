local function create_modal_window(text)
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)

    local width = 1
    local height = 10

    for i = 1, #text do
        if #text[i] > width then
            width = #text[i]
        end
    end

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "single"
    }

    vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':q<CR>', { noremap = true, silent = true })
end

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

    create_modal_window(modal_content)
end

function FileInfo()
    local filename = vim.fn.expand('%')

    local modal_content = { "File: " .. filename }

    create_modal_window(modal_content)
end

function RunCurrentLine()
  local current_line = vim.api.nvim_get_current_line()
  -- vim.cmd("!" .. current_line)
  local output = vim.fn.systemlist({ "zsh", "-c", current_line })
  create_modal_window(output)
end
