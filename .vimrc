" ~/.vimrc

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

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



"" enable vim-plug
call plug#begin('~/.vim/plugged')

" Easy navigation between tmux panes and vim windows
Plug 'christoomey/vim-tmux-navigator'

" Darcula like theme
Plug 'doums/darcula'

" Plug's finisher
call plug#end()


