
function Abc()
    local notify = require('notify')
    pcall(notify, "This is my message3", vim.log.levels.WARN, {
        title = "Some Title",
        icon = "",
        timeout = 5000,
    })
end

vim.keymap.set("n", "<leader>1", "<cmd>lua Abc()<CR>")
