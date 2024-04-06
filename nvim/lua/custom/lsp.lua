local lsp_file = "/Users/andrius/src/educationalsp/educationalsp"

if not (vim.fn.filereadable(lsp_file) == 1) then
    return
end

local client = vim.lsp.start_client({
    name = "testlsp",
    cmd = { lsp_file },
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
