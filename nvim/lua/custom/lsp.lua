local function init_my_lsp()
    local lsp_file = "learnlsp"

    local ok = os.execute("which " .. lsp_file)
    if ok ~= 0 and ok ~= true then
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
end

init_my_lsp()
