-- vim.g ----------------------------------------------------------------------
local g = vim.g

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0

g.mapleader = ' '
g.maplocalleader = ' '

-- g.netrw_banner = 0
-- g.netrw_keepdir = 0
-- g.netrw_winsize = 30

g.transparency = 0.98

if g.neovide == true then
    g.neovide_background_color = '#0f1117' .. string.format(
        '%x', math.floor((255 * g.transparency) or 0.8)
    )
    g.neovide_floating_blur_amount_x = 2.0
    g.neovide_floating_blur_amount_y = 2.0
    g.neovide_refresh_rate = 30
    g.neovide_refresh_rate_idle = 15
    g.neovide_scroll_animation_length = 0.3
    g.neovide_transparency = 0.99
end

-- vim.opt --------------------------------------------------------------------
local o = vim.opt

-- o.autochdir = true
-- o.autoindent = true
-- o.autoread = true
o.autowrite = true
-- o.autowriteall = true

o.background = 'dark'
o.breakindent = true
o.browsedir = 'buffer'

o.clipboard = 'unnamedplus'
-- o.cmdheight = 0
o.colorcolumn = '80,100'
o.completeopt = { 'menuone', 'preview', 'noselect' }
o.conceallevel = 3
o.cursorline = true

o.expandtab = true

o.fileencoding = 'utf-8'
o.fileformats = 'unix,dos'
-- o.fillchars = { vert = '│', horiz = '─', eob = ' ' }
o.fillchars = {
  foldopen = '',
  foldclose = '',
  -- fold = '⸱',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}
o.formatoptions = 'jcroqlnt'

o.grepformat = '%f:%l:%c:%m'
o.grepprg = 'rg --vimgrep'
o.guicursor = 'n-v-c:block,'
    ..'i-ci-ve:ver25,'
    ..'r-cr:hor20,'
    ..'o:hor50,'
    ..'a:blinkwait2000-blinkoff2000-blinkon2000-Cursor/lCursor,'
    ..'sm:block-blinkwait175-blinkoff150-blinkon175'
o.guifont = 'FiraMono Nerd Font:h12'

o.laststatus = 3
o.lazyredraw = false
o.list = true
-- o.listchars:append 'lead:.'
o.listchars:append 'nbsp:+'
o.listchars:append 'space: '
o.listchars:append 'tab:> '
o.listchars:append 'trail:¤'

-- o.modeline = false
-- o.mouse = "nivh"

o.number = true

o.previewheight = 5

-- o.relativenumber = true

o.scrolloff = 7
-- o.shada = [['20,<50,s10,h,/100]]
o.shiftwidth = 4
o.shortmess:append 'c'
-- o.showmatch = true
-- o.showmode = false
o.signcolumn = 'yes'
-- o.smartcase = true
-- o.smartindent = true
-- o.softtabstop = 0
-- o.splitbelow = true
-- o.splitright = true
o.synmaxcol = 500

o.tabstop = 4
o.termguicolors = true
-- o.textwidth = 80
o.timeoutlen = 200

-- o.undofile = true
-- o.updatetime = 100

o.wildignore = { '*.o', '*~', '*.pyc' }
o.whichwrap:append '<,>'
o.wildmode = 'longest:full,full'

