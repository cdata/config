if &compatible
  set nocompatible
endif

call plug#begin()

Plug 'ctrlpvim/ctrlp.vim'
Plug 'morhetz/gruvbox'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'rhysd/vim-clang-format'
Plug 'ervandew/supertab'
Plug 'ryanoasis/vim-devicons'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" JavaScript & TypeScript
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim' " syntax files
Plug 'Quramy/vim-js-pretty-template'

" HTML
"Plug 'othree/html5.vim'
"Plug 'docunext/closetag.vim'

" CSS
Plug 'ap/vim-css-color'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Rust
Plug 'rust-lang/rust.vim'

" Misc
Plug 'tomlion/vim-solidity'
Plug 'tikhomirov/vim-glsl'

call plug#end()

syntax enable
filetype plugin indent on

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

" Hide the annoying omnicomplete preview window
"set completeopt-=preview

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

" TypeScript config
" Syntastic will handle error reporting (see below)
let g:tsuquyomi_disable_quickfix = 1

" Syntastic config
let g:syntastic_html_checkers = []
"let g:syntastic_html_htmlhint_args = "--rules doctype-first=false"
let g:syntastic_typescript_checkers = ['tsuquyomi']

" Ctrl+P config
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules|bower_components$',
  \ }

" NERDCommenter config
let NERDComInsertMap='<c-c>'
let mapleader=","

" Deoplete config
let g:deoplete#enable_at_startup = 1

" Pretty template literals for html only
call jspretmpl#register_tag('html', 'html')

"autocmd FileType javascript,typescript JsPreTmpl javascript

" Better Whitespace config
autocmd BufEnter * EnableStripWhitespaceOnSave

" Fully re-highlight file when necessary. This is supposedly slow, but it is
" definitely more accurate
autocmd BufEnter * :syntax sync fromstart
