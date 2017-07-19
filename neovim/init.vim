if &compatible
  set nocompatible
endif

call plug#begin()

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
"Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'
Plug 'morhetz/gruvbox'
Plug 'tomlion/vim-solidity'
Plug 'tikhomirov/vim-glsl'

call plug#end()

syntax enable
filetype plugin indent on

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

" Syntastic config
let g:syntastic_html_checkers = []
"let g:syntastic_html_htmlhint_args = "--rules doctype-first=false"

" Ctrl+P config
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules|bower_components$',
  \ }

" NERDCommenter config
let NERDComInsertMap='<c-c>'
let mapleader=","

" Deoplete config
let g:deoplete#enable_at_startup = 1

" Better Whitespace config
autocmd BufEnter * EnableStripWhitespaceOnSave

" Fully re-highlight file when necessary. This is supposedly slow, but it is
" definitely more accurate
autocmd BufEnter * :syntax sync fromstart
