-- stylua: ignore start
-- General ====================================================================

vim.opt.termguicolors = true

vim.g.mapleader       = ' '            -- Use <Space> as a leader key

vim.o.mouse           = 'a'            -- Enable mouse
vim.o.mousescroll     = 'ver:25,hor:6' -- Customize mouse scroll
vim.o.switchbuf       = 'usetab'       -- Use already opened buffers when switching
vim.o.undofile        = true           -- Enable persistent undo
vim.o.encoding        = 'utf-8'
vim.o.fileencoding    = 'utf-8'

vim.o.shada           = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file

-- Enable all filetype plugins and syntax
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- UI =========================================================================
vim.o.breakindent    = true -- Indent wrapped lines
vim.o.breakindentopt = 'list:-1'
vim.o.colorcolumn    = '+1'
vim.o.cursorline     = true
vim.o.cursorlineopt  = 'screenline,number'
vim.o.linebreak      = true
vim.o.list           = false
vim.o.number         = true
vim.o.relativenumber = true
vim.o.pumheight      = 15
vim.o.pumblend       = 2
vim.o.ruler          = false
vim.o.shortmess      = 'CFOSWaco'
vim.o.showmode       = false
vim.o.signcolumn     = 'yes'
vim.o.splitbelow     = true
vim.o.splitkeep      = 'screen'
vim.o.splitright     = true
vim.o.wrap           = false
vim.o.scrolloff      = 10
vim.o.winborder      = 'rounded'
vim.o.winminwidth    = 10
vim.o.cmdheight      = 0
vim.o.laststatus     = 3
vim.o.smoothscroll   = true
vim.o.wildmode       = 'longest:full,full'

-- Special UI symbols
vim.o.fillchars      = 'eob: ,fold:╌'
vim.o.listchars      = "tab:→ ,trail:·,extends:…,precedes:…"

-- Folds
vim.o.foldlevel   = 1
vim.o.foldmethod  = 'indent'
vim.o.foldnestmax = 10

-- Neovim version specific
if vim.fn.has('nvim-0.11') == 1 then
  vim.o.winborder = 'double' -- Use border in floating windows
  -- Disable "press-enter" for messages not from manually executing a command
  vim.o.messagesopt = 'wait:500,history:500'
  local make_set_messagesopt = function(value) return vim.schedule_wrap(function() vim.o.messagesopt = value end) end
  _G.Config.new_autocmd('CmdlineEnter', '*', make_set_messagesopt('hit-enter,history:500'))
  _G.Config.new_autocmd('CmdlineLeave', '*', make_set_messagesopt('wait:500,history:500'))
end

if vim.fn.has('nvim-0.12') == 1 then
  vim.o.pummaxwidth = 100 -- Limit maximum width of popup menu
  vim.o.completefuzzycollect = 'keyword,files,whole_line' -- Use fuzzy matching when collecting candidates
  vim.o.completetimeout = 100

  vim.o.pumborder = 'double'

  require('vim._extui').enable({ enable = true })
  end
-- Editing ====================================================================
vim.o.autoindent    = true
vim.o.expandtab     = true
vim.o.formatoptions = 'jcroqlnt'
vim.o.ignorecase    = true
vim.o.incsearch     = true
vim.o.infercase     = true
vim.o.shiftwidth    = 2
vim.o.smartcase     = true
vim.o.smartindent   = true
vim.o.tabstop       = 2
vim.o.smarttab      = true
vim.o.virtualedit   = 'block'
vim.o.completeopt   = 'menuone,noselect'
vim.o.complete      = '.,w,b,kspell'
vim.o.confirm       = true
vim.o.hlsearch      = true
vim.o.updatetime    = 200
vim.o.undolevels    = 10000
vim.o.backup        = false
vim.o.showcmd       = true
vim.o.jumpoptions   = 'view'
vim.o.inccommand    = 'nosplit'
vim.o.grepformat    = '%f:%l:%c:%m'
vim.o.grepprg       = 'rg --vimgrep'

vim.o.spelllang     = 'en,uk,ru'
vim.o.spelloptions  = 'camel'
-- vim.o.iskeyword     = '@,48-57,_,192-255,-'
-- vim.o.dictionary    = vim.fn.stdpath('config') .. '/misc/dict/english.txt'
-- vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Clipboard
vim.o.clipboard     = vim.env.SSH_TTY and '' or 'unnamedplus'

-- Search completion behavior
if vim.fn.has('nvim-0.11') == 1 then
  vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
end

-- Undercurl support
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Autocommands ===============================================================
local ensure_fo = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
_G.Config.new_autocmd('FileType', '*', ensure_fo, "Proper 'formatoptions'")

-- Diagnostics ================================================================
local diagnostic_opts = {
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
    source = "always",
    header = "",
    border = "double",
    focusable = false,
  },
  virtual_text = true,
  underline = { severity = { min = 'HINT', max = 'ERROR' } },
  virtual_lines = false,
  update_in_insert = false,
}
MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)
-- stylua: ignore end
