local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { import = "plugins" },

  { 'andriusm/toolbox.nvim' },
  { 'andriusm/nvim-avro' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-bundler' },
  { 'folke/sidekick.nvim' },
  { 'fatih/vim-go' },
  { 'theprimeagen/harpoon' },
  { 'mbbill/undotree' },
  { 'vim-test/vim-test' },
  { 'folke/which-key.nvim',  opts = {} },
  { 'theHamsta/nvim-dap-virtual-text' },
  { 'nvim-telescope/telescope-dap.nvim' },
  { "immanuwell/droast.nvim" },
}, {})
