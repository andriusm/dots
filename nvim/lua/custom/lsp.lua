local client = vim.lsp.start_client({
    name = "testlsp",
    cmd = { "/Users/andrius/src/educationalsp/educationalsp" },
    filetypes = { "markdown" },
})

if not client then
    print("Failed to start LSP client")
    return
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.lsp.buf_attach_client(0, client)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.lsp.buf_attach_client(0, client)
    end,
})
