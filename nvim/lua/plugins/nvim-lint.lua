vim.filetype.add({
  pattern = {
    ['.*/%.github/workflows/.*%.ya?ml'] = 'yaml.ghaction',
    ['.*/api/openapi/.*%.ya?ml'] = 'yaml.openapi',
    ['.*/api/asyncapi/.*%.ya?ml'] = 'yaml.asyncapi',
  },
})

return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')

      lint.linters_by_ft = {
        ghaction = { 'actionlint' },
        openapi = { 'redocly' },
        asyncapi = { 'spectral' },
        go = { 'golangcilint' },
        dockerfile = { 'hadolint' },
        gitcommit = { 'gitlint' },
        markdown = { 'markdownlint-cli2' },
        sql = { 'sqruff' },
      }

      -- Linters run on every buffer regardless of filetype.
      local global_linters = { 'gitleaks' }

      -- Spectral: use project ruleset when present, else the global fallback.
      local spectral = require('lint.linters.spectral')
      lint.linters.spectral = function()
        local args = { 'lint', '-f', 'json' }
        local local_ruleset = vim.fs.find(function(name)
          return name:match('^%.spectral%.') ~= nil
        end, { upward = true, path = vim.fn.expand('%:p:h') })[1]
        if not local_ruleset then
          vim.list_extend(args, { '--ruleset', vim.fn.expand('~/.config/spectral/.spectral.yaml') })
        end
        spectral.args = args
        return spectral
      end

      -- Sqruff only reads .sqruff from its exact cwd, so resolve the config
      -- ourselves: project .sqruff (upward from the buffer) or the home fallback.
      local sqruff = require('lint.linters.sqruff')
      lint.linters.sqruff = function()
        local config = vim.fs.find('.sqruff', { upward = true, path = vim.fn.expand('%:p:h') })[1]
          or vim.fn.expand('~/.config/sqruff/.sqruff')
        sqruff.args = { 'lint', '--config', config, '--format=json', '-' }
        return sqruff
      end

      -- Install all configured linters via Mason if missing.
      -- Keys are nvim-lint names, values are Mason package names where they differ.
      local mason_names = {
        golangcilint = 'golangci-lint',
      }
      vim.defer_fn(function()
        require('mason')
        local registry = require('mason-registry')
        local seen = {}
        for _, linters in pairs(vim.list_extend({ global_linters }, vim.tbl_values(lint.linters_by_ft))) do
          for _, linter in ipairs(linters) do
            local name = mason_names[linter] or linter
            if not seen[name] then
              seen[name] = true
              local ok, pkg = pcall(registry.get_package, name)
              if ok and not pkg:is_installed() then
                vim.notify('Mason: installing ' .. name)
                pkg:install()
              end
            end
          end
        end
      end, 3000)

      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = function()
          lint.try_lint(nil, { ignore_errors = true })
          for _, linter in ipairs(global_linters) do
            lint.try_lint(linter, { ignore_errors = true })
          end
        end,
      })
    end,
  },
}
