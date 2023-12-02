
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

  for id, node in query:iter_captures(root, 0, 0, -1) do
    local name = vim.treesitter.get_node_text(node, 0)
    print(name)
  end
end

vim.keymap.set("n", "<leader>1", "<cmd>lua ExtractMethodNames()<CR>")
-- vim.keymap.set("n", "<leader>1", "<cmd>lua Abc()<CR>")
