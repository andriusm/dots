-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Go to next diagnostic message' })
--vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- older keymap

vim.keymap.set("n", "<leader>ve", ":edit $HOME/.config/nvim/init.lua<CR>")
vim.keymap.set("n", "<leader>vl", ":edit $HOME/.config/lf/lfrc<CR>")
vim.keymap.set("n", "<leader>vw", ":edit $HOME/.config/wezterm/wezterm.lua<CR>")
vim.keymap.set("n", "<leader>vz", ":edit $HOME/.config/zsh/.zshrc<CR>")

vim.keymap.set("n", ";", ":")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<leader>fm", function() vim.lsp.buf.format() end)

vim.keymap.set("n", "Q", "<nop>")

-- ??
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- from prev config

vim.keymap.set("n", "<C-\\>", ":vsplit<CR>")
vim.keymap.set("n", "gf", ":edit <cfile><cr>")

vim.keymap.set("n", "<leader>vr", ":source $HOME/.config/nvim/init.lua<cr>")

vim.keymap.set("n", "<leader>hk", ":nohlsearch<CR>", { desc = 'Clear search highlight' })
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = 'Delete buffer' })

vim.keymap.set("n", "<leader>T", ":vsplit | terminal<CR>i")

-- fm-nvim
--vim.keymap.set("n", "-", ":Lf<CR>")

-- copilot
vim.keymap.set("i", "<C-p>", "<cmd>call copilot#Previous()<cr>")
vim.keymap.set("i", "<C-n>", "<cmd>call copilot#Next()<cr>")
vim.keymap.set("i", "<C-Bslash>", "<cmd>call copilot#Suggest()<cr>")
vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
  bg = '#dddd33',
  fg = '#333333',
  ctermfg = 8,
})

-- copilot plugin
if vim.fn.exists(":Copilot") == 2 then
  vim.keymap.set("n", "<leader>ce", ":Copilot enable<cr>")
  vim.keymap.set("n", "<leader>cd", ":Copilot disable<cr>")
end

-- git plugin
if vim.fn.exists(":G") == 2 then
  vim.keymap.set("n", "<leader>gk", ":G blame<cr>")
  vim.keymap.set("n", "<leader>gl", ":0Gclog<cr>")
  vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<cr>")
end

-- harpoon plugin

vim.keymap.set("n", "<leader>a", function() require('harpoon.mark').add_file() end)
vim.keymap.set("n", "<leader>e", function() require('harpoon.ui').toggle_quick_menu() end, { desc = 'Harpoon: toggle quick menu' })
vim.keymap.set("n", "<leader>1", function() require('harpoon.ui').nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() require('harpoon.ui').nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() require('harpoon.ui').nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() require('harpoon.ui').nav_file(4) end)
vim.keymap.set("n", "<leader>5", function() require('harpoon.ui').nav_file(5) end)
vim.keymap.set("n", "<leader>6", function() require('harpoon.ui').nav_file(6) end)
vim.keymap.set("n", "<leader>7", function() require('harpoon.ui').nav_file(7) end)
vim.keymap.set("n", "<leader>8", function() require('harpoon.ui').nav_file(8) end)
vim.keymap.set("n", "<leader>9", function() require('harpoon.ui').nav_file(9) end)
vim.keymap.set("n", "<leader>0", function() require('harpoon.ui').nav_file(0) end)

-- undotree plugin

if vim.fn.exists(":UndotreeToggle") == 2 then
  vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
end

-- vim-test plugin

if vim.fn.exists(":TestFile") == 2 then
  vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>")
  vim.keymap.set("n", "<leader>tf", ":TestFile<CR>")
  vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>")
  vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")
  vim.keymap.set("n", "<leader>tv", ":TestVisit<CR>")
end

-- debugging

vim.keymap.set("n", "<F5>", function() require('dap').continue() end)
vim.keymap.set("n", "<F7>", function() require('dap').step_into() end)
vim.keymap.set("n", "<F8>", function() require('dap').step_over() end)
vim.keymap.set("n", "<F9>", function() require('dap').toggle_breakpoint() end)
vim.keymap.set("n", "<F12>", function() require('dap').repl.toggle() end)

-- telescope
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', function() require('telescope.builtin').live_grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sj', function() require('telescope.builtin').git_files() end, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sw', function()
  local current_word = vim.fn.expand("<cword>")
  require('telescope.builtin').live_grep({ default_text = current_word })
end)
vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').diagnostics() end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', function() require('telescope.builtin').resume() end, { desc = '[S]earch [R]resume' })

vim.keymap.set("n", "<leader>b", function() require('telescope.builtin').buffers() end)
vim.keymap.set("n", "<leader>rc", function() require('telescope.builtin').oldfiles() end)
vim.keymap.set("n", "<leader>o", function() require('telescope.builtin').lsp_document_symbols() end)
vim.keymap.set("n", "<leader>fc", function() require('telescope.builtin').commands() end)

vim.keymap.set("n", "<leader>vv", function()
  require('telescope.builtin').find_files({
    prompt_title = 'Find dotfiles',
    cwd = vim.fn.stdpath('config'),
  })
end)

vim.keymap.set('n', '<leader>?', function() require('telescope.builtin').oldfiles() end, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', function() require('telescope.builtin').buffers() end, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>skg', function()
  require('telescope.builtin').live_grep({
    glob_pattern="*.rb",
    prompt_title = 'Search Ruby Files',
  })
end, { desc = '[S]earch [K]only-rb [G]rep' })

vim.keymap.set('n', '<leader>skl', function()
  require('telescope.builtin').live_grep({
    glob_pattern = '*.rb',
    prompt_title = 'Search Ruby non-spec files',
    hidden = true,
    file_ignore_patterns = { "_spec%.rb$" }
  })
end, { desc = '[S]earch [K]non-spec-rb [G]rep' })

vim.keymap.set('n', '<leader>scg', function()
  local filepath = vim.fn.expand('%:p:h')
  require('telescope.builtin').live_grep({ cwd = filepath })
end, { desc = '[S]earch [C]urrent-dir [G]rep' })

-- meta 

vim.keymap.set('n', '<space><space>x', ':source %<CR>')
vim.keymap.set('n', '<space>xx', ':.lua<CR>')
vim.keymap.set('v', '<space>xx', ':lua<CR>')
vim.keymap.set("n", "<leader>de", ':lua vim.diagnostic.enable()<CR>')
vim.keymap.set("n", "<leader>dd", ':lua vim.diagnostic.disable()<CR>')
vim.keymap.set("n", "<space>z",  function()
  local current_line = vim.api.nvim_get_current_line()
  local output = vim.fn.systemlist({ "zsh", "-c", current_line })
  require('toolbox.utils').create_modal_window(output)
end)

-- quickfix (j/k = next/prev; <leader>hk = nohlsearch to avoid conflict)
vim.keymap.set("n", "<leader>j", ":cnext<CR>", { desc = 'Quickfix: next' })
vim.keymap.set("n", "<leader>k", ":cprev<CR>", { desc = 'Quickfix: previous' })

-- custom
vim.keymap.set('n', '<leader>fi', function() require('toolbox').file_info() end)

vim.keymap.set('v', '<leader>xd', ':lua decode_base64_selection()<CR>')
vim.keymap.set('v', '<leader>xe', ':lua encode_base64_selection()<CR>')
vim.keymap.set('v', '<leader>xu', ':lua urldecode_selection()<CR>')

vim.keymap.set("n", "<leader>xc", function()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end)
vim.keymap.set("n", "<leader>xo", function() require('toolbox.git').find_pr_of_current_line() end)

vim.keymap.set("n", "<localleader>w", '<cmd>ExecuteHttpRequest<CR>')
vim.keymap.set("n", "<leader>xl", "<cmd>lua OpenKibanaLogs()<CR>")
vim.keymap.set("n", "<leader>xf", "<cmd>lua OpenFeature()<CR>")
vim.keymap.set("n", "<leader>xr", "<cmd>lua CoreRevision()<CR>")
