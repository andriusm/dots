function Abc()
  local notify = require('notify')
  pcall(notify, "This is my message3", vim.log.levels.WARN, {
    title = "Some Title",
    icon = "",
    timeout = 5000,
  })
end

function ExtractMethodNames()
  local parser = vim.treesitter.get_parser(0, 'ruby')
  local tree = parser:parse()[1]
  local root = tree:root()

  local query = vim.treesitter.query.parse('ruby', [[
    (method (identifier) @method-name)
  ]])

  -- local query = vim.treesitter.query.parse('ruby', [[
  --     (assignment left: (instance_variable) @asdf)
  -- ]])

  -- local query = vim.treesitter.query.parse('ruby', [[
  --     (call method: (identifier) @method-name)
  -- ]])

  for _, node in query:iter_captures(root, 0, 0, -1) do
    local name = vim.treesitter.get_node_text(node, 0)
    print(name)
  end
end


-- --------------------------------------------------------------------------------

function checkTodoItem()
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
        vim.api.nvim_buf_set_keymap(0, 'n', '<F2>', ':lua checkTodoItem()<CR>', {noremap = true, silent = true})
    end
})

-- --------------------------------------------------------------------------------

function OpenPR()
  local file_name = vim.api.nvim_buf_get_name(0)
  local line_number = vim.api.nvim_win_get_cursor(0)[1]

  local pr_command = "git log -1 $(git blame -L " .. line_number .. "," .. line_number .. " " .. file_name .. " | cut -d ' ' -f 1 | sed 's/^\\^//') |  grep -o '#[0-9]\\+' | sed 's/#//'"
  local pr = vim.fn.system(pr_command):gsub("%s+", "")

  if pr == "" then
    print("PR not found, this was probably merged straight to master")
    return
  end

  local base_command = "git remote -v | grep '(fetch)' | sed 's/^.*@//;s/ .*$//;s/:/\\//;s/\\.git//'"
  local base = vim.fn.system(base_command):gsub("%s+", "")

  local url = "https://" .. base .. "/pull/" .. pr
  vim.fn.system("open '" .. url .. "'")
end

vim.keymap.set("n", "<leader>go", "<cmd>lua OpenPR()<CR>")

-- --------------------------------------------------------------------------------

local function openFloatingWindowWithBorder()
    -- Window size
    local width = 50
    local height = 10
    local row = math.ceil((vim.o.lines - height) / 2) - 1
    local col = math.ceil((vim.o.columns - width) / 2) - 1

    -- Create a buffer for the content
    local content_buf = vim.api.nvim_create_buf(false, true)

    -- Define the lines you want to display
    local lines = { "lorem ipsum sit amet dolor. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet.",
    "Line 2", "Line 3" }

    -- Set lines in the buffer
    vim.api.nvim_buf_set_lines(content_buf, 0, -1, false, lines)

    -- Create content window
    local content_opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col
    }
    local content_win = vim.api.nvim_open_win(content_buf, true, content_opts)

    -- Create a buffer for the border
    local border_buf = vim.api.nvim_create_buf(false, true)

    -- Create border window
    local border_opts = {
        style = "minimal",
        relative = "editor",
        width = width + 2,
        height = height + 2,
        row = row - 1,
        col = col - 1
    }
    local border_win = vim.api.nvim_open_win(border_buf, false, border_opts)

    -- Draw the border (using box-drawing characters)
    local border_lines = { "╭" .. string.rep("─", width) .. "╮" }
    for i = 1, height do
        table.insert(border_lines, "│" .. string.rep(" ", width) .. "│")
    end
    table.insert(border_lines, "╰" .. string.rep("─", width) .. "╯")
    vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)
    
    -- --------------------

    local function closeAllWindows()
        vim.api.nvim_win_close(content_win, true)
        vim.api.nvim_win_close(border_win, true)
    end

    -- Set keymap for the content buffer to close the window on pressing Esc
    vim.api.nvim_buf_set_keymap(content_buf, 'n', '<Esc>', '', {
        noremap = true,
        silent = true,
        callback = closeAllWindows
    })

    -- Optionally, set the same keymap for the border buffer
    vim.api.nvim_buf_set_keymap(border_buf, 'n', '<Esc>', '', {
        noremap = true,
        silent = true,
        callback = closeAllWindows
    })

end

-- Create a Neovim command to call this function
vim.api.nvim_create_user_command('OpenFloatingWindowWithBorder', openFloatingWindowWithBorder, {})


-- vim.keymap.set("n", "<leader>1", "<cmd>lua Abc()<CR>")

-- --------------------------------------------------------------------------------

-- print(vim.fn.environ()["HOME"])
-- print(vim.fn.cusor)

-- --------------------------------------------------------------------------------
--
local function execute_http_request()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local in_comment = false
  local comment_lines = {}
  local start_line, end_line

  -- Find the first multiline comment
  for i, line in ipairs(lines) do
    if line:match("/%*") then
      in_comment = true
      start_line = i
    end
    if in_comment then
      table.insert(comment_lines, line)
    end
    if line:match("%*/") then
      in_comment = false
      end_line = i
      break
    end
  end

  if not start_line or not end_line then
    print("No multiline comment found")
    return
  end

  -- Extract HTTP verb, URL, and JSON body
  -- local http_verb, url = comment_lines[2]:match("/%*(%w+)%s+\"([^\"]+)\"")
  local http_verb, url = comment_lines[2]:match("(%w+) (http?://.*)")
  local json_body = table.concat(comment_lines, "\n", 3, #comment_lines - 1)

  if not http_verb or not url then
    print("Invalid comment format")
    return
  end

  -- Prepare curl command
  local curl_cmd
  if http_verb == "POST" then
    curl_cmd = string.format('curl -s -X %s -d \'%s\' %s', http_verb, json_body, url)
  else
    curl_cmd = string.format('curl -s -X %s %s', http_verb, url)
  end

  -- Execute curl command
  local handle = io.popen(curl_cmd)
  local response = handle:read("*a")
  handle:close()

  if response:sub(-1) == "\n" then
    response = response:sub(1, -2)
  end

  local response_lines = vim.split(response, '\n')
  vim.api.nvim_buf_set_lines(bufnr, end_line + 1, end_line + #response_lines + 1, false, response_lines)
  --
  -- use this to add new lines, instead of replacing
  -- vim.api.nvim_buf_set_lines(bufnr, end_line + 1, end_line + #response_lines, false, response_lines)
end

-- Command to call the function
vim.api.nvim_create_user_command('ExecuteHttpRequest', execute_http_request, {})
vim.keymap.set("n", "<localleader>w", '<cmd>ExecuteHttpRequest<CR>')


