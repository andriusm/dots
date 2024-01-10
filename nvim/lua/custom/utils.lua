
-- function urldecode(str)
--     str = string.gsub(str, '+', ' ')
--     str = string.gsub(str, '%%(%x%x)', function(h)
--         return string.char(tonumber(h, 16))
--     end)
--     return str
-- end

function _G.urldecode_selection()
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

    if #lines == 0 then return end

    local text = table.concat(lines, '\n')
    text = text:gsub('+', ' '):gsub('%%(%x%x)', function(h)
        return string.char(tonumber(h, 16))
    end)

    local decoded_lines = {}
    for line in text:gmatch("([^\n]*)\n?") do
        table.insert(decoded_lines, line)
    end

    vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, end_pos[1], false, decoded_lines)
end

-- --------------------------------------------------------------------------------

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function base64_decode(data)
    data = data:gsub('[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i - 1) > 0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2^(8 - i) or 0) end
        return string.char(c)
    end))
end

local function base64_encode(data)
    return ((data:gsub('.', function(x) 
        local r, b = '', x:byte()
        for i = 8, 1, -1 do r = r .. (b % 2^i - b % 2^(i - 1) > 0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c = 0
        for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2^(6 - i) or 0) end
        return b:sub(c + 1, c + 1)
    end)..({ '', '==', '=' })[#data % 3 + 1])
end

-- Function to encode selected text in Neovim
function _G.encode_base64_selection()
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

    if #lines == 0 then return end

    local text = table.concat(lines, '\n')
    text = base64_encode(text)

    local encoded_lines = {}
    for line in text:gmatch("([^\n]*)\n?") do
        table.insert(encoded_lines, line)
    end

    vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, end_pos[1], false, encoded_lines)
end

-- Function to decode selected text in Neovim
function _G.decode_base64_selection()
    local start_pos = vim.api.nvim_buf_get_mark(0, '<')
    local end_pos = vim.api.nvim_buf_get_mark(0, '>')
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

    if #lines == 0 then return end

    local text = table.concat(lines, '\n')
    text = base64_decode(text)

    local decoded_lines = {}
    for line in text:gmatch("([^\n]*)\n?") do
        table.insert(decoded_lines, line)
    end

    vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, end_pos[1], false, decoded_lines)
end

-- --------------------------------------------------------------------------------

function _G.grep_current_word()
    local current_word = vim.fn.expand("<cword>")
    require('telescope.builtin').live_grep({ default_text = current_word })
end


vim.api.nvim_set_keymap('n', '<leader>xf', ':lua grep_current_word()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>xu', ':lua urldecode_selection()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>xd', ':lua decode_base64_selection()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>xe', ':lua encode_base64_selection()<CR>', { noremap = true, silent = true })
