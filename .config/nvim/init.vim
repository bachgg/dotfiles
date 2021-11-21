set nocompatible              " be iMproved, required
filetype off                  " required

" Remap leader key
let mapleader = ";"
nnoremap <Leader>b :ls<CR>:b<Space>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" treesitter for parsing language, which is used for autocompleting, syntax
" highlighting, go-to-definition...
Plugin 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update


" NERDTree
Plugin 'preservim/nerdtree'

" vim-polyglot for syntax highlighting
Plugin 'sheerun/vim-polyglot'

" Nerd commenter
Plugin 'preservim/nerdcommenter'

" Rust
Plugin 'rust-lang/rust.vim'

if has('nvim') || has('patch-8.0.902')
  Plugin 'mhinz/vim-signify'
else
  Plugin 'mhinz/vim-signify', {'branch': 'legacy'}
endif

" Show buffers as tab
Plugin 'ap/vim-buftabline'

" CoC Code Completion
Plugin 'neoclide/coc.nvim'

" Theme: Sonokai
Plugin 'sainnhe/sonokai'

" Theme: One dark
Plugin 'joshdick/onedark.vim'

" Theme: One
" Plugin 'rakr/vim-one'

" Lightline: status bar
Plugin 'itchyny/lightline.vim'

" command-t
" Plugin 'git://git.wincent.com/command-t.git'
call vundle#end()           

" Set line number
set number

" Set relative line number from current line
set relativenumber

" Color scheme
" Important!!
if has('termguicolors')
  set termguicolors
endif
" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_style = 'atlantis'

let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 0

" These two weird lines help displaying italic correctly
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
syntax on
colorscheme sonokai

" Lightline option
let g:lightline = {'colorscheme' : 'sonokai'}
set laststatus=2
set noshowmode
" let g:sonokai_diagnostic_line_highlight = 1

" tmux color support
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Time out between pressing ESC in INSERT mode and when it's back to NORMAL
" mode
set timeoutlen=1000
set ttimeoutlen=0

" CoC settings
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Switch buffers
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>
