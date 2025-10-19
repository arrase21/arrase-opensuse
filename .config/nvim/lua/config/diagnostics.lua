vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "ErrorMsg",
    },
    numhl = {
      [vim.diagnostic.severity.WARN] = "WarningMsg",
    },
  },
  float = {
    source = "always",     -- Show the source of the message
    header = "",           -- No header
    border = "single",     -- Use a single-line border
    focusable = false,
  },
  -- Add virtual text to display the message right next to the code
  virtual_text = true,
})
