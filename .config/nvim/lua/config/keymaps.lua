local map = vim.keymap.set
local opts = { noremap = true, silent = true }
-- Press kj fast to enter
map("i", "kj", "<ESC>", opts)
map("i", "KJ", "<ESC>", opts)
-- Quit
map("n", "<Leader>w", ":w<ESC>", opts)
-- Move text up and down
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
-- Delete word
map("n", "<backspace>", "diw", opts)
-- Copy paste
map("n", "<Leader>y", "mzyyp`zj", opts)
-- Delete a word backwards
map("n", "dw", 'vb"_d')
-- Select all
map("n", "<C-a>", "gg<S-v>G")
-- Split window
map("n", "ss", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)
-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>:bwipeout <cr>", { desc = "Delete Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })
-- Clear search, diff update and redraw
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- picker
map("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "Find Files" })
map("n", "<leader>fb", "<Cmd>Pick buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fg", "<Cmd>Pick grep_live<CR>", { desc = "Finf Grep" })
-- picker
map("n", "<leader>o", "<Cmd>lua MiniFiles.open()<CR>", { desc = "󰱼 Find Files" })
-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    -- map("<leader>cd", require("snacks").picker.lsp_definitions, "Goto Definition")
    -- map("<leader>cr", require("snacks").picker.lsp_references, "Goto References")
    -- map("<leader>cI", require("snacks").picker.lsp_implementations, "Goto Implementation")
    -- -- map("<leader>D", require("snacks").picker.lsp_type_definitions, "Type [D]efinition")
    -- map("<leader>cS", require("snacks").picker.lsp_symbols, "Document Symbols")
    -- map("<leader>cs", require("snacks").picker.lsp_workspace_symbols, "Workspace Symbols")
    -- map("<leader>cn", vim.lsp.buf.rename, "Reame")
    -- map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
    -- map("<leader>cf", vim.lsp.buf.format, "Format")
    map("K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, "Hover Documentation")
    map("<leader>cD", vim.lsp.buf.declaration, "Goto Declaration")
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
        end,
      })
    end
  end,
})

-- Navegar sugerencias con Tab y Shift-Tab
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, noremap = true })

vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, noremap = true })

-- Confirmar con Enter
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  end
  return "<CR>"
end, { expr = true, noremap = true })

-- map("i", "(", "()<Left>")
-- map("i", "[", "[]<Left>")
-- map("i", "{", "{}<Left>")
--
-- map("i", "\"", "\"\"<Left>")
-- map("i", "'", "''<Left>")
-- map("i", "`", "``<Left>")
--
-- Basic mappings =============================================================

-- Shorter version of the most frequent way of going outside of terminal window
vim.keymap.set('t', '<C-h>', [[<C-\><C-N><C-w>h]])

-- Paste linewise before/after current line
local cmd = vim.fn.has('nvim-0.12') == 1 and 'iput' or 'put'
vim.keymap.set('n', '[p', '<Cmd>exe "' .. cmd .. '! " . v:register<CR>', { desc = 'Paste Above' })
vim.keymap.set('n', ']p', '<Cmd>exe "' .. cmd .. ' "  . v:register<CR>', { desc = 'Paste Below' })

-- Many general mappings are created by 'mini.basics'. See 'plugin/30_mini.lua'

-- Leader mappings ============================================================
-- stylua: ignore start

-- Create global tables with information about clue groups in certain modes
-- Structure of tables is taken to be compatible with 'mini.clue'.
_G.Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'n', keys = '<Leader>L', desc = '+Lua/Log' },
  { mode = 'n', keys = '<Leader>m', desc = '+Map' },
  { mode = 'n', keys = '<Leader>o', desc = '+Other' },
  { mode = 'n', keys = '<Leader>r', desc = '+R' },
  { mode = 'n', keys = '<Leader>s', desc = '+Session' },
  { mode = 'n', keys = '<Leader>t', desc = '+Terminal/Minitest' },
  { mode = 'n', keys = '<Leader>T', desc = '+Test' },
  { mode = 'n', keys = '<Leader>v', desc = '+Visits' },

  { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'x', keys = '<Leader>r', desc = '+R' },
}

-- Create `<Leader>` mappings
local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end

-- b is for 'Buffer'
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end
nmap_leader('ba', '<Cmd>b#<CR>', 'Alternate')
map("n", "<leader>bd", "<cmd>:bwipeout <cr>", { desc = "Delete Buffer" })
-- nmap_leader('bD', '<Cmd>lua MiniBufremove.delete(0, true)<CR>',  'Delete!')
nmap_leader('bs', new_scratch_buffer, 'Scratch')
nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
nmap_leader('bW', '<Cmd>lua MiniBufremove.wipeout(0, true)<CR>', 'Wipeout!')

-- e is for 'Explore' and 'edit'
local edit_config_file = function(filename)
  return string.format('<Cmd>edit %s/plugin/%s<CR>', vim.fn.stdpath('config'), filename)
end
local explore_at_file = '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>'
local explore_quickfix = function()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.fn.getwininfo(win_id)[1].quickfix == 1 then return vim.cmd('cclose') end
  end
  vim.cmd('copen')
end

nmap_leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
nmap_leader('ef', explore_at_file, 'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>', 'init.lua')
nmap_leader('ek', edit_config_file('keymaps.lua'), 'Keymaps config')
nmap_leader('em', edit_config_file('mini.lua'), 'MINI config')
nmap_leader('en', '<Cmd>lua MiniNotify.show_history()<CR>', 'Notifications')
nmap_leader('eo', edit_config_file('10_options.lua'), 'Options config')
nmap_leader('ep', edit_config_file('40_plugins.lua'), 'Plugins config')
nmap_leader('es', '<Cmd>lua MiniSessions.select()<CR>', 'Sessions')
nmap_leader('eq', explore_quickfix, 'Quickfix')

-- f is for 'Fuzzy find'
local pick_added_hunks_buf = '<Cmd>Pick git_hunks path="%" scope="staged"<CR>'
nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>', '"/" history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>', '":" history')
nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
nmap_leader('fA', pick_added_hunks_buf, 'Added hunks (buf)')
nmap_leader('fb', '<Cmd>Pick buffers<CR>', 'Buffers')
nmap_leader('fc', '<Cmd>Pick git_commits<CR>', 'Commits (all)')
nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>', 'Commits (buf)')
nmap_leader('fd', '<Cmd>Pick diagnostic scope="all"<CR>', 'Diagnostic workspace')
nmap_leader('fD', '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>', 'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
nmap_leader('fG', '<Cmd>Pick grep pattern="<cword>"<CR>', 'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>', 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>', 'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>', 'Lines (all)')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (buf)')
nmap_leader('fm', '<Cmd>Pick git_hunks<CR>', 'Modified hunks (all)')
nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>', 'Modified hunks (buf)')
nmap_leader('fr', '<Cmd>Pick resume<CR>', 'Resume')
nmap_leader('fp', '<Cmd>Pick projects<CR>', 'Projects')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fs', '<Cmd>Pick lsp scope="workspace_symbol"<CR>', 'Symbols workspace')
nmap_leader('fS', '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')
nmap_leader('fv', '<Cmd>Pick visit_paths cwd=""<CR>', 'Visit paths (all)')
nmap_leader('fV', '<Cmd>Pick visit_paths<CR>', 'Visit paths (cwd)')

-- g is for 'Git'
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'
nmap_leader('ga', '<Cmd>Git diff --cached<CR>', 'Added diff')
nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>', 'Added diff buffer')
nmap_leader('gc', '<Cmd>Git commit<CR>', 'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>', 'Commit amend')
nmap_leader('gd', '<Cmd>Git diff<CR>', 'Diff')
nmap_leader('gD', '<Cmd>Git diff -- %<CR>', 'Diff buffer')
nmap_leader('gg', '<Cmd>lua Config.open_lazygit()<CR>', 'Git tab')
nmap_leader('gl', '<Cmd>' .. git_log_cmd .. '<CR>', 'Log')
nmap_leader('gL', '<Cmd>' .. git_log_buf_cmd .. '<CR>', 'Log buffer')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at cursor')

xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')

-- l is for 'Language'
local formatting_cmd = '<Cmd>lua require("conform").format({ lsp_fallback = true })<CR>'
nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', 'Actions')
nmap_leader('ld', '<Cmd>lua vim.diagnostic.open_float()<CR>', 'Diagnostic popup')
nmap_leader('lf', formatting_cmd, 'Format')
nmap_leader('li', '<Cmd>lua vim.lsp.buf.hover()<CR>', 'Hover')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>', 'References')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', 'Rename')
nmap_leader('ls', '<Cmd>lua vim.lsp.buf.definition()<CR>', 'Source definition')

-- L is for 'Lua'
nmap_leader('Lc', '<Cmd>lua Config.log_clear()<CR>', 'Clear log')
nmap_leader('LL', '<Cmd>luafile %<CR><Cmd>echo "Sourced lua"<CR>', 'Source buffer')
nmap_leader('Ls', '<Cmd>lua Config.log_print()<CR>', 'Show log')
nmap_leader('Lx', '<Cmd>lua Config.execute_lua_line()<CR>', 'Execute `lua` line')

-- m is for 'Map'
nmap_leader('mf', '<Cmd>lua MiniMap.toggle_focus()<CR>', 'Focus (toggle)')
nmap_leader('mr', '<Cmd>lua MiniMap.refresh()<CR>', 'Refresh')
nmap_leader('ms', '<Cmd>lua MiniMap.toggle_side()<CR>', 'Side (toggle)')
nmap_leader('mt', '<Cmd>lua MiniMap.toggle()<CR>', 'Toggle')

-- r is for 'R'
-- - Mappings starting with `T` send commands to current neoterm buffer, so
--   some sort of R interpreter should already run there
nmap_leader('rc', '<Cmd>T devtools::check()<CR>', 'Check')
nmap_leader('rC', '<Cmd>T devtools::test_coverage()<CR>', 'Coverage')
nmap_leader('rd', '<Cmd>T devtools::document()<CR>', 'Document')
nmap_leader('ri', '<Cmd>T devtools::install(keep_source=TRUE)<CR>', 'Install')
nmap_leader('rk', '<Cmd>T rmarkdown::render("%")<CR>', 'Knit file')
nmap_leader('rl', '<Cmd>T devtools::load_all()<CR>', 'Load all')
nmap_leader('rT', '<Cmd>T testthat::test_file("%")<CR>', 'Test file')
nmap_leader('rt', '<Cmd>T devtools::test()<CR>', 'Test')

-- - Copy to clipboard and make reprex (which itself is loaded to clipboard)
xmap_leader('rx', '"+y :T reprex::reprex()<CR>', 'Reprex selection')

-- s is for 'Session'
-- t is for 'Terminal' (uses 'neoterm') and 'minitest'
nmap_leader('ta', '<Cmd>lua MiniTest.run()<CR>', 'Test run all')
nmap_leader('tf', '<Cmd>lua MiniTest.run_file()<CR>', 'Test run file')
nmap_leader('tl', '<Cmd>lua MiniTest.run_at_location()<CR>', 'Test run location')
nmap_leader('ts', '<Cmd>lua Config.minitest_screenshots.browse()<CR>', 'Test show screenshot')
nmap_leader('tT', '<Cmd>belowright Tnew<CR>', 'Terminal (horizontal)')
nmap_leader('tt', '<Cmd>vertical Tnew<CR>', 'Terminal (vertical)')

-- T is for 'Test'
nmap_leader('TF', '<Cmd>TestFile -strategy=make | copen<CR>', 'File (quickfix)')
nmap_leader('Tf', '<Cmd>TestFile<CR>', 'File')
nmap_leader('TL', '<Cmd>TestLast -strategy=make | copen<CR>', 'Last (quickfix)')
nmap_leader('Tl', '<Cmd>TestLast<CR>', 'Last')
nmap_leader('TN', '<Cmd>TestNearest -strategy=make | copen<CR>', 'Nearest (quickfix)')
nmap_leader('Tn', '<Cmd>TestNearest<CR>', 'Nearest')
nmap_leader('TS', '<Cmd>TestSuite -strategy=make | copen<CR>', 'Suite (quickfix)')
nmap_leader('Ts', '<Cmd>TestSuite<CR>', 'Suite')

-- v is for 'Visits'
local make_pick_core = function(cwd, desc)
  return function()
    local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
    local local_opts = { cwd = cwd, filter = 'core', sort = sort_latest }
    MiniExtra.pickers.visit_paths(local_opts, { source = { name = desc } })
  end
end
