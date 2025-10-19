local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ name = 'mini.nvim', checkout = 'HEAD' })

-- now(function() vim.cmd('colorscheme miniwinter') end)

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function()
  local predicate = function(notif)
    if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then return true end
    -- Filter out some LSP progress notifications from 'lua_ls'
    return notif.msg:find('Diagnosing') == nil and notif.msg:find('semantic tokens') == nil
  end
  local custom_sort = function(notif_arr) return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr)) end

  require('mini.notify').setup({ content = { sort = custom_sort } })
end)

now(function() require('mini.starter').setup() end)

now(function() require('mini.tabline').setup() end)

-- Future part of 'mini.detect'
-- TODO: Needs some condition to stop the comb.
_G.detect_bigline = function(threshold)
  threshold = threshold or 1000
  local step = math.floor(0.5 * threshold)
  local cur_line, cur_byte = 1, step
  local byte2line = vim.fn.byte2line
  while cur_line > 0 do
    local test_line = byte2line(cur_byte)
    if test_line == cur_line and #vim.fn.getline(test_line) >= threshold then return cur_line end
    cur_line, cur_byte = test_line, cur_byte + step
  end
  return -1
end

-- Unfortunately, `_lines` is ~3x faster
_G.get_all_indent_lines = function()
  local res, lines = {}, vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i = 1, #lines do
    local indent = lines[i]:match('^%s+')
    if indent ~= nil then table.insert(res, indent) end
  end
  return res
end

_G.get_all_indent_text = function()
  local res, n = {}, vim.api.nvim_buf_line_count(0)
  local get_text = vim.api.nvim_buf_get_text
  for i = 1, n do
    local first_byte = get_text(0, i - 1, 0, i - 1, 1, {})[1]
    if first_byte == '\t' or first_byte == ' ' then table.insert(res, vim.fn.getline(i):match('^%s+')) end
  end
  return res
end

-- Unfortunately, `_lines` is 10x faster
_G.get_maxwidth_lines = function()
  local res, lines = 0, vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i = 1, #lines do
    res = res < lines[i]:len() and lines[i]:len() or res
  end
  return res
end

_G.get_maxwidth_bytes = function()
  local res, n = 0, vim.api.nvim_buf_line_count(0)
  local cur_byte, line2byte = 1, vim.fn.line2byte
  for i = 2, n + 1 do
    local new_byte = line2byte(i)
    res = math.max(res, new_byte - cur_byte)
    cur_byte = new_byte
  end
  return res - 1
end

-- Step two ===================================================================
later(function() require('mini.extra').setup() end)

later(function()
  add({ source = "Exafunction/windsurf.vim" })
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end
  require('mini.completion').setup({
    sources = { codeium_source },
    lsp_completion = { source_func = 'omnifunc', auto_setup = false, process_items = process_items },
  })
  local on_attach = function(args) vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end
  _G.Config.new_autocmd('LspAttach', '*', on_attach, 'Custom `on_attach`')
  if vim.fn.has('nvim-0.11') == 1 then vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() }) end

  vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  vim.keymap.set('i', '<C-[>', function() return vim.fn['codeium#CycleCompletions'](1) end,
    { expr = true, silent = true })
  vim.keymap.set('i', '<C-]>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
    { expr = true, silent = true })
end)

later(function()
  require('mini.diff').setup({
    view = {
      style = "sign",
      signs = { add = '▒', change = '▒', delete = '消' },
    }
  })
end)

later(function()
  require('mini.files').setup(
    {
      windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 15,
        width_preview = 85,
      },
      mappings = {
        go_in_plus = "<CR>",       -- Entrar y abrir en ventana reciente
        synchronize = "<Leader>w", -- Remapear sincronización a <Leader>w
      },
    })

  _G.Config.new_autocmd('User', 'MiniFilesExplorerOpen', function()
    MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
    MiniFiles.set_bookmark('m', vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim', { desc = 'mini.nvim' })
    MiniFiles.set_bookmark('p', vim.fn.stdpath('data') .. '/site/pack/deps/opt', { desc = 'Plugins' })
    MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
  end, "Create 'mini.files' bookmarks")
end)

later(function() require('mini.git').setup() end)

later(function() require('mini.indentscope').setup() end)


later(function() require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = false } }) end)

later(function()
  require('mini.pick').setup()
  vim.keymap.set('n', ',', '<Cmd>Pick buf_lines scope="current" preserve_order=true<CR>', { nowait = true })
  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/repos')
    local choose = function(item)
      vim.schedule(function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end)
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end
end)

later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    window = {
      delay = 100,
      scroll_down = '<C-d>',
      scroll_up = '<C-u>',
    },
    clues = {
      { mode = 'n', keys = '<Leader>c', desc = '  Coding' },
      { mode = 'n', keys = '<Leader>b', desc = '󰓩  Buffers' },
      { mode = 'n', keys = '<Leader>f', desc = '󰱼  Files' },
      { mode = 'n', keys = '<Leader>q', desc = '󰗼  Quit/Session' },
      { mode = 'n', keys = '<Leader>u', desc = '  UI/Toggles' },
      { mode = 'n', keys = '<Leader>w', desc = '  Windows' },
      { mode = 'n', keys = '<Leader>d', desc = '  Debug' },
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = 'n', keys = '<Leader>' }, -- Leader triggers
      { mode = 'x', keys = '<Leader>' },
      { mode = 'n', keys = [[\]] },      -- mini.basics
      { mode = 'n', keys = '[' },        -- mini.bracketed
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'i', keys = '<C-x>' }, -- Built-in completion
      { mode = 'n', keys = 'g' },     -- `g` key
      { mode = 'x', keys = 'g' },
      { mode = 'n', keys = "'" },     -- Marks
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      { mode = 'n', keys = '"' }, -- Registers
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      { mode = 'n', keys = '<C-w>' }, -- Window commands
      { mode = 'n', keys = 'z' },     -- `z` key
      { mode = 'x', keys = 'z' },
    },
  })
end)
