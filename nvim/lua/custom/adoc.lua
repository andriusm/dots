vim.api.nvim_create_autocmd("FileType", {
  pattern = "asciidoc",
  callback = function()
    local template_file = vim.fn.expand("~/.config/nvim/templates/template.adoc")

    if vim.fn.filereadable(template_file) == 1 then
      if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
        vim.cmd("0r " .. template_file)
      end
    else
      print("Template file not found!")
    end
  end,
})
