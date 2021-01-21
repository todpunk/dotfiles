" ~/.vimrc

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

"" enable vim-plug
call plug#begin('~/.vim/plugged')

" Easy navigation between tmux panes and vim windows
Plug 'christoomey/vim-tmux-navigator'


" Plug's finisher
call plug#end()


" line numbers on and gray
set number
highlight LineNr ctermfg=grey
" more powerful backspacing
set backspace=indent,eol,start   
