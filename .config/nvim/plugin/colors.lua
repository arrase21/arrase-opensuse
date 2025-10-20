local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and now or later

later(function()
add('brenoprata10/nvim-highlight-colors')

require('nvim-highlight-colors').setup({})
end)
