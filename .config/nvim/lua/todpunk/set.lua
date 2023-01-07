--##### SETS AND COLORS #####

-- Spacing and tabbing related
vim.opt.backspace="indent,eol,start"
vim.opt.expandtab=true
vim.opt.shiftwidth=4
vim.opt.smartindent=true
vim.opt.smarttab=true
vim.opt.tabstop=4
vim.opt.softtabstop=4

vim.opt.guicursor = ""
vim.opt.colorcolumn="120"
vim.opt.exrc=true
vim.opt.hidden=true
vim.opt.hlsearch=false
vim.opt.errorbells=false
vim.opt.wrap=false
vim.opt.number=true
vim.opt.relativenumber=true
vim.opt.scrolloff=8
vim.opt.signcolumn="yes"
vim.opt.termguicolors=true

-- line numbers grey
vim.cmd[[highlight LineNr ctermfg=grey]]
-- colorcolumn should be grey instead of red or whatever
vim.cmd[[highlight ColorColumn ctermbg=darkblue guibg=darkblue]]

