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
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

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

vim.keymap.set("n", "<leader>k", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", ":bdelete<CR>")

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

-- colors
function flipBackgroundColor()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end

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

local has_harpoon, _ = pcall(require, "harpoon")
if has_harpoon then
  local mark = require('harpoon.mark')
  local ui = require('harpoon.ui')

  vim.keymap.set("n", "<leader>a", mark.add_file)
  vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)
  vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
  vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
  vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
  vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
  vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end)
  vim.keymap.set("n", "<leader>6", function() ui.nav_file(6) end)
  vim.keymap.set("n", "<leader>7", function() ui.nav_file(7) end)
  vim.keymap.set("n", "<leader>8", function() ui.nav_file(8) end)
  vim.keymap.set("n", "<leader>9", function() ui.nav_file(9) end)
  vim.keymap.set("n", "<leader>0", function() ui.nav_file(0) end)
end

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

local has_dap, _ = pcall(require, "dap")
if has_dap then
  vim.keymap.set("n", "<F5>", "<cmd>lua require('dap').continue()<cr>")
  vim.keymap.set("n", "<F7>", "<cmd>lua require('dap').step_into()<cr>")
  vim.keymap.set("n", "<F8>", "<cmd>lua require('dap').step_over()<cr>")
  vim.keymap.set("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<cr>")
  vim.keymap.set("n", "<F12>", "<cmd>lua require('dap').repl.toggle()<cr>")
end

-- telescope
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sj', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sw', ':lua grep_current_word()<CR>')
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]resume' })

vim.keymap.set("n", "<leader>b", require('telescope.builtin').buffers)
vim.keymap.set("n", "<leader>rc", require('telescope.builtin').oldfiles)
vim.keymap.set("n", "<leader>o", require('telescope.builtin').lsp_document_symbols)
vim.keymap.set("n", "<leader>fc", require('telescope.builtin').commands)

vim.keymap.set("n", "<leader>vv", function()
  require('telescope.builtin').find_files({
    prompt_title = 'Find dotfiles',
    cwd = vim.fn.stdpath('config'),
  })
end)

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
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
vim.keymap.set("n", "<leader>de", ':lua vim.diagnostics.enable()<CR>')
vim.keymap.set("n", "<leader>dd", ':lua vim.diagnostics.disable()<CR>')
vim.keymap.set("n", "<space>z",  ":lua RunCurrentLine()<CR>")

-- custom
vim.keymap.set("n", "<localleader>w", '<cmd>ExecuteHttpRequest<CR>')
vim.keymap.set("n", "<leader>xc", "<cmd>lua flipBackgroundColor()<cr>")
vim.keymap.set("n", "<leader>xo", "<cmd>lua OpenPR()<CR>")
vim.keymap.set('v', '<leader>xu', ':lua urldecode_selection()<CR>')
vim.keymap.set('v', '<leader>xd', ':lua decode_base64_selection()<CR>')
vim.keymap.set('v', '<leader>xe', ':lua encode_base64_selection()<CR>')
vim.keymap.set("n", "<leader>xl", "<cmd>lua OpenKibanaLogs()<CR>")
vim.keymap.set("n", "<leader>xf", "<cmd>lua OpenFeature()<CR>")
vim.keymap.set("n", "<leader>xr", "<cmd>lua CoreRevision()<CR>")
