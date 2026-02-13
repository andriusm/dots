return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle", "CopilotChatExplain", "CopilotChatReview", "CopilotChatFix", "CopilotChatOptimize", "CopilotChatDocs", "CopilotChatTests", "CopilotChatCommit" },
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {},
  },
}
