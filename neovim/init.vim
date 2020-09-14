if &compatible
  set nocompatible
endif

call plug#begin()

" QOL
Plug 'ctrlpvim/ctrlp.vim'
Plug 'morhetz/gruvbox'
Plug 'terryma/vim-multiple-cursors'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
"Plug 'vim-syntastic/syntastic'
Plug 'rhysd/vim-clang-format'
"Plug 'ervandew/supertab'
"Plug 'ryanoasis/vim-devicons'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" JavaScript & TypeScript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim' " syntax files
"Plug 'cdata/vim-tagged-template'
"Plug 'Quramy/tsuquyomi'

" HTML
"Plug 'othree/html5.vim'
"Plug 'docunext/closetag.vim'

" CSS
Plug 'ap/vim-css-color'

" Go
"Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Rust
"Plug 'rust-lang/rust.vim'

" Misc
"Plug 'tomlion/vim-solidity'
Plug 'tikhomirov/vim-glsl'

call plug#end()

syntax enable
filetype plugin indent on

" Always use the system clipboard in neovim
set clipboard=unnamedplus

" Higher frequency for things like gitgutter
set updatetime=75

" Set the color scheme
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
colorscheme gruvbox

" Fixes backspace on the terminal
set backspace=2

" Line numbering
set nu

" Auto-indent by file type
set autoindent

" Show command in the last line of the screen
set sc

" Set tabs to two spaces + smart indentation
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

" Show vertical lines at these comma-separated columns
set colorcolumn=80

" Make the current line more obvious
set cursorline

" minimum lines to keep above/below cursor
set scrolloff=5

" Enable mouse in all modes
set mouse=a

" Visibly display tab/eol characters
set list
set listchars=tab:▸\ ,eol:¬

" Add row / columnn information
set ruler

" Highlight search
set hls

" Wrap text instead of being on one line
set lbr

" Ctrl-P config
" use silver searcher for listing files in ctrlp
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" it's so fast we don't need a file cache
let g:ctrlp_use_caching = 0

" TypeScript config
" Syntastic will handle error reporting (see below)
let g:tsuquyomi_disable_quickfix = 1

" Syntastic config
let g:syntastic_html_checkers = []
"let g:syntastic_html_htmlhint_args = "--rules doctype-first=false"
let g:syntastic_typescript_checkers = ['tsuquyomi']

let g:syntastic_always_populate_loc_list = 1
" Automatically open/close error window
let g:syntastic_auto_loc_list = 1
" Combine errors from different checkers
let g:syntastic_aggregate_errors = 1
" Check as soon as a file is opened
let g:syntastic_check_on_open = 1
" Skip checks when exiting
let g:syntastic_check_on_wq = 0
" Allow TypeScript decorators
let g:syntastic_typescript_tsc_post_args='--experimentalDecorators'
" There are lots of tools for checking go code
let g:syntastic_go_checkers = ['go', 'gofmt', 'govet', 'golint']

" Ctrl+P config
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules|bower_components$',
  \ }

" NERDCommenter config
let NERDComInsertMap='<c-c>'
let mapleader=","

" Deoplete config
let g:deoplete#enable_at_startup = 1

" Clang Format config
" Special style config for clang-format
let g:clang_format#style_options = {
    \ "BasedOnStyle" : "Google",
    \ "AlignAfterOpenBracket" : "AlwaysBreak",
    \ "AllowAllParametersOfDeclarationOnNextLine" : "false",
    \ "AllowShortBlocksOnASingleLine" : "false",
    \ "AllowShortCaseLabelsOnASingleLine" : "false",
    \ "AllowShortFunctionsOnASingleLine" : "None",
    \ "AllowShortIfStatementsOnASingleLine" : "false",
    \ "AllowShortLoopsOnASingleLine" : "false",
    \ "BinPackArguments" : "false",
    \ "BinPackParameters" : "false"}

" Auto-enable clang-format for relevant filetypes
autocmd FileType javascript,typescript ClangFormatAutoEnable

" Tagged Template config
let g:taggedtemplate#tagSyntaxMap = {
  \ "html": "html",
  \ "md": "markdown",
  \ "css": "css" }

" autocmd FileType javascript,typescript : call taggedtemplate#applySyntaxMap()

" Better Whitespace config
autocmd BufEnter * EnableStripWhitespaceOnSave

" Fully re-highlight file when necessary. This is supposedly slow, but it is
" definitely more accurate
autocmd BufEnter * :syntax sync fromstart

" Some custom keymappings
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>m :NERDTreeFind<CR>
nmap <leader>s :SyntasticCheck<CR>
nmap <leader>S :SyntasticReset<CR>
" Search/replace word under cursor
nmap <leader>z :%s/\<<C-r><C-w>\>//g<left><left>
