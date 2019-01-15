set nocompatible
filetype off
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'scrooloose/nerdtree'
Plugin 'fatih/vim-go'
Plugin 'rust-lang/rust.vim'
call vundle#end()
filetype plugin indent on
if has("syntax")
  syntax enable
endif
colorscheme gruvbox
set encoding=utf-8
set t_Co=256
set background=dark
set history=5000
set undolevels=5000
set ffs=unix,dos
set nobackup
set nowritebackup
set noswapfile
set number
set tabstop=4
set softtabstop=2
set shiftwidth=4
set autoindent
set copyindent
set expandtab
set hlsearch
set scrolloff=5
set splitbelow
set splitright
set autoread
set backspace=2
set wildmenu
set showmatch
set spell
set list
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif
let g:go_version_warning=0
