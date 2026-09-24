vim.filetype.add({
  pattern = {
    ['.*/%.github/workflows/.*%.ya?ml'] = 'yaml.ghaction',
  },
})

return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufWritePost', 'InsertLeave' },
    config = function()
      local lint = require('lint')

      lint.linters_by_ft = {
        ghaction = { 'actionlint' },
      }

      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = function()
          lint.try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}
