if &compatible
  set nocompatible
endif

call plug#begin()

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-fugitive'
Plug 'morhetz/gruvbox'

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

" Add row / columnn information
set ruler

" Highlight search
set hls

" Wrap text instead of being on one line
set lbr

" Hide the annoying omnicomplete preview window
"set completeopt-=preview

" Ctrl+P config
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules|bower_components$',
  \ }

" NERDCommenter config
let NERDComInsertMap='<c-c>'
let mapleader=","

" Deoplete config
let g:deoplete#enable_at_startup = 1

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

