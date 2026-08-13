return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {
    filetypes = { "*" },
    user_default_options = {
      RGB = true,          -- Fix for #RGB strings
      RRGGBB = true,       -- Fix for #RRGGBB strings
      names = false,       -- Disables plain words like "blue" or "red"
      css = false,         -- Disables css functions if you only want Hex
    },
  },
}
