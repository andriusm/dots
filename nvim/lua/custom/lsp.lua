local lsp_file = "learnlsp"

local exit_code = os.execute("which " .. lsp_file)

if not (exit_code == 0) then
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
    pattern = "markdown,ruby",
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
