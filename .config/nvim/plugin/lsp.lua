local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"
for _, file in ipairs(vim.fn.globpath(lsp_dir, "*.lua", false, true)) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  if name ~= "diagnostics" then
    local config = require("lsp." .. name)
    vim.lsp.config[name] = config
    vim.lsp.enable(name)
  end
end

-- Formatting =================================================================
-- later(function()
--   add('stevearc/conform.nvim')
--
--   require('conform').setup({
--     -- Map of filetype to formatters
--     formatters_by_ft = {
--       javascript = { 'prettier' },
--       json = { 'prettier' },
--       lua = { 'stylua' },
--       go = { "goimports-reviser", "gofumpt", "golines" },
--     },
--     format_on_save = {
--       lsp_fallback = true,
--       timeout_ms = 3000,
--     },
--   })
-- end)
