set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath


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
call plug#begin()

" Linter
Plug 'dense-analysis/ale'

" Completion
" Doesn't work in NeoVim < 0.5.0
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" Some I'm trying from https://www.integralist.co.uk/posts/neovim/
Plug 'folke/trouble.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'j-hui/fidget.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'm-demare/hlargs.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'simrat39/rust-tools.nvim'
Plug 'weilbith/nvim-code-action-menu'
Plug 'williamboman/nvim-lsp-installer'

" Plug's finisher
call plug#end()

" Config for plugins

" ------------------------------------
" j-hui/fidget.nvim
" ------------------------------------
"
lua require("fidget").setup()

" ------------------------------------
" kosayoda/nvim-lightbulb
" ------------------------------------
"
autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()

" ------------------------------------
" weilbith/nvim-code-action-menu
" ------------------------------------
"
let g:code_action_menu_window_border = 'single'

" ------------------------------------
" folke/trouble.nvim
" ------------------------------------
"
lua require("trouble").setup()

" ------------------------------------
" Neovim LSP
" ------------------------------------
"
" Configure Rust LSP.
"
" https://github.com/simrat39/rust-tools.nvim#configuration
"
lua <<EOF
local opts = {
  -- rust-tools options
  tools = {
    autoSetHints = true,
  -- hover_with_actions = true,
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
      },
    },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
  -- https://rust-analyzer.github.io/manual.html#features
  server = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate"
          },
        cargo = {
          allFeatures = true
          },
        checkOnSave = {
          -- default: `cargo check`
          command = "clippy"
          },
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true
          },
        },
      }
    },
}
require('rust-tools').setup(opts)
EOF

" Configure Golang LSP.
"
" https://github.com/golang/tools/blob/master/gopls/doc/settings.md
" https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
" https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
" https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
" https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
" https://www.getman.io/posts/programming-go-in-neovim/
"
lua <<EOF
require('lspconfig').gopls.setup{
	cmd = {'gopls'},
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      experimentalPostfixCompletions = true,
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
    },
  },
	on_attach = on_attach,
}
EOF

" Configure Golang Environment.
"
fun! GoFumpt()
  :silent !gofumpt -w %
  :edit
endfun
autocmd FileType go map <buffer> <leader>p :call append(".", "fmt.Printf(\"%+v\\n\", )")<CR> <bar> :norm $a<CR><esc>j==$i
autocmd FileType go map <buffer> <leader>e :call append(".", "if err != nil {return err}")<CR> <bar> :w<CR>
autocmd BufWritePost *.go call GoFumpt()
autocmd BufWritePost *.go :cex system('revive '..expand('%:p')) | cwindow

" Order imports on save, like goimports does:
"
lua <<EOF
  function OrgImports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end
EOF
autocmd BufWritePre *.go lua OrgImports(1000)

" Configure LSP code navigation shortcuts
" as found in :help lsp
"
nnoremap <silent> <c-]>     <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <c-k>     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K         <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gc        <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <silent> gd        <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr        <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gn        <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gs        <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gw        <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Replaced LSP implementation with code action plugin...
"
" nnoremap <silent> ga        <cmd>lua vim.lsp.buf.code_action()<CR>
"
nnoremap <silent> ga        <cmd>CodeActionMenu<CR>

nnoremap <silent> [x        <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> ]x        <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> ]s        <cmd>lua vim.diagnostic.show()<CR>

" Replaced LSP implementation with trouble plugin...
"
" nnoremap <silent> <space>q  <cmd>lua vim.diagnostic.setloclist()<CR>
"
nnoremap <silent> <space>q  <cmd>Trouble<CR>

" Setup Completion
" https://github.com/hrsh7th/nvim-cmp#recommended-configuration
"
lua <<EOF
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' },
  },
})
EOF

" Setup Treesitter and friends
"
" NOTE: originally used `ensure_installed = "all"` but an experimental PHP
" parser was causing NPM lockfile errors.
"
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = { "bash", "c", "cmake", "css", "dockerfile", "go", "gomod", "gowork", "hcl", "help", "html", "http", "javascript", "json", "lua", "make", "markdown", "python", "regex", "ruby", "rust", "toml", "vim", "yaml", "zig" },
  highlight = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}
require('hlargs').setup()
EOF

"""" AUTOCOMMANDS """"

" tab preferences by filetype
autocmd Filetype yaml setlocal ts=2 sw=2 expandtab
autocmd Filetype go setlocal ts=4
