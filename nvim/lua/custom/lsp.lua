local function init_my_lsp()
    local lsp_file = "learnlsp"

    if vim.fn.executable(lsp_file) ~= 1 then
        return
    end

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "ruby" },
        callback = function()
            vim.lsp.start({
                name = "testlsp",
                cmd = { lsp_file },
            })
        end,
    })
end

init_my_lsp()
