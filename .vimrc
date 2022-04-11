" ~/.vimrc

" Start fresh setting things
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim


"""" SETS AND COLORS """"

" Spacing and tabbing related
set backspace=indent,eol,start   
set expandtab
set shiftwidth=4
set smartindent
set tabstop=4 softtabstop=4

set colorcolumn=120
set exrc
set hidden
set nohlsearch
set noerrorbells
set nowrap
set number
set relativenumber
set scrolloff=8
set signcolumn=yes
set termguicolors

" line numbers grey
highlight LineNr ctermfg=grey
" colorcolumn should be grey instead of red or whatever
highlight ColorColumn ctermbg=darkblue guibg=darkblue


"""" PLUGINS """"

"" enable vim-plug
call plug#begin('~/.vim/plugged')

" Linter
Plug 'dense-analysis/ale'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Darcula like theme
Plug 'doums/darcula'

" Make Vim a good go editor
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Nerdtree needs no comment
Plug 'preservim/nerdtree'

" Status line update
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ONLY for the status line stuff
Plug 'tpope/vim-fugitive'

" Put git line status in the left
Plug 'airblade/vim-gitgutter'

" Easy navigation between tmux panes and vim windows
Plug 'christoomey/vim-tmux-navigator'

" Plug's finisher
call plug#end()


"""" AUTOCOMMANDS """"

" tab preferences by filetype
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab
autocmd Filetype go setlocal ts=4
