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

vim.keymap.set("n", "<leader>ve", ":edit $HOME/.config/nvim/lua/base/init.lua<CR>")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
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

vim.keymap.set("n", "<leader>fm", function()
  vim.lsp.buf.format()
end)

vim.keymap.set("n", "Q", "<nop>")

-- ??
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- from prev config

vim.keymap.set("n", "<C-\\>", ":vsplit<CR>")
vim.keymap.set("n", "gf", ":edit <cfile><cr>")

vim.keymap.set("n", "<leader>vr", ":source ~/.config/nvim/init.lua<cr>")

vim.keymap.set("n", "<leader>k", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", ":bdelete<CR>")

vim.keymap.set("n", "<leader>T", ":vsplit | terminal<CR>i")

vim.keymap.set("n", "<F4>", function()
  vim.cmd(':Ex ' .. vim.fn.getcwd())
end)

-- fm-nvim
vim.keymap.set("n", "-", ":Lf<CR>")

-- copilot
vim.keymap.set("i", "<C-p>", "<cmd>call copilot#Previous()<cr>")
vim.keymap.set("i", "<C-n>", "<cmd>call copilot#Next()<cr>")
vim.keymap.set("i", "<C-Bslash>", "<cmd>call copilot#Suggest()<cr>")
vim.keymap.set("i", "<C-j>", "<cmd>call copilot#Accept()<cr>")

-- colors
function flipBackgroundColor()
  if vim.o.background == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end

vim.keymap.set("n", "<leader>cc", "<cmd>lua flipBackgroundColor()<cr>")
