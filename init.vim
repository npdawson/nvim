" Specify a dir for plugins
call plug#begin('~/.config/nvim/plugged')

" Neovim LSP Client
Plug 'neovim/nvim-lspconfig'

" LSP Auto-complete, status, and diagnostic info
Plug 'nvim-lua/completion-nvim'
"Plug 'nvim-lua/lsp-status.nvim' " TODO: configure status line to include additional information
"Plug 'nvim-lua/diagnostic-nvim'

" fancy parser generator for colorful highlighting
Plug 'nvim-treesitter/nvim-treesitter'

" fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'

" themes
Plug 'drewtempelmeyer/palenight.vim'
Plug 'glepnir/zephyr-nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'dracula/vim',{'as':'dracula'}

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" status bar
Plug 'itchyny/lightline.vim'

" more awesome tpope plugins
Plug 'tpope/vim-commentary'     " shortcuts for commenting lines
Plug 'tpope/vim-apathy'         " sets path options to nice defaults
Plug 'tpope/vim-unimpaired'     " shortcuts that come in pairs
Plug 'tpope/vim-surround'       " keybinds that change surrounding characters []{}()etc.

" Initialize plugin system
call plug#end()

" spaces & tabs
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " use spaces instead of tabs
set autoindent
set smartindent     " does the right thing (mostly)
set copyindent      " copy indent from the previous line
set cindent         " stricter rules for C programs
set cino=t0,(0,=0   " t0 - Indent a function return type declaration in column 0.
                    "      (default 'shiftwidth').
                    " (0 - When in unclosed parentheses, line up subsequent
                    "      lines with the first non-white character after the 
                    "      unclosed parentheses.  (default 'shiftwidth' * 2).
                    " =0 - Place statements occurring after a case label 0 characters from
                    "      the indent of the label.  (default 'shiftwidth').


" UI stuff
set hidden
set updatetime=100  " 100ms instead of the default 4000, as recommended by gitgutter
set signcolumn=yes  " always show, otherwise gitgutter et al will shift the text
set cursorline      " highlight current line
set showmatch       " highlight matching brace
set mouse=a         " enable the mouse in all modes
if (exists('+colorcolumn')) " set column 100 to a different color to indicate 'max' line length
    set colorcolumn=100
    "highlight ColorColumn ctermbg=9
endif

" tweaks for file browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide=',\(^\|\s\s\)\zs\.\S\+'

" search
set ignorecase      " ignore case when searching
set smartcase       " but only when it's all lowercase 

" finding files
" search into subfolders
"set path+=**

" theme & colors
set termguicolors   " enable true color mode
syntax enable       " enable syntax highlighting
let g:vimsyn_embed = 'l'    " enable highlighting of lua code embedded in vimscript files
set background=dark
"let g:palenight_terminal_italics = 1
"let g:gruvbox_italic = 1
"let g:gruvbox_contrast_dark = 'hard'
"let g:dracula_colorterm = 0 " unset background color to enable transparency
colorscheme dracula

" lightline customization
let g:lightline = { 
            \      'colorscheme': 'dracula',
            \      'active': {
            \      'left': [ [ 'mode', 'paste' ],
            \                [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \      },
            \      'component_function': {
            \      'gitbranch': 'FugitiveHead'
            \      },
            \ }

" leader key
let g:mapleader = "\<Space>"
" turn off search highlights
nnoremap <silent> <leader><space> :nohlsearch<CR>
" fugitive shortcuts
nmap <leader>gs :G<CR>
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
" fzf shortcuts
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <C-f> :Rg
" some other nice leader shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Lua stuff
lua << EOF
-- LSP servers
local lsp = require'nvim_lsp'
local on_attach = function(client)
    require'completion'.on_attach(client)
--    require'diagnostic'.on_attach(client)
end
lsp.ccls.setup{on_attach=on_attach}
lsp.vimls.setup{on_attach=on_attach}

-- treesitter setup
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", 
                                     -- "maintained" (parsers with maintainers), 
                                     -- or a list of languages
    highlight = {
        enable = false, -- false will disable the whole extension
        disable = {},  -- list of languages to disable
    },
}

-- zephyr setup
--require('zephyr').get_zephyr_color()
EOF

" LSP shortcuts
"nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" LSP completion
autocmd Filetype cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc 
autocmd Filetype vim setlocal omnifunc=v:lua.vim.lsp.omnifunc 

" LSP auto-completion config
" use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Enable fuzzy matching
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" avoid showing message extra message when using completion
set shortmess+=c
