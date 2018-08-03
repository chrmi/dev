call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript'
Plug 'roxma/nvim-yarp'
Plug 'morhetz/gruvbox'
let g:deoplete#enable_at_startup = 1
call plug#end()
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
set tabstop=2
set softtabstop=2
set shiftwidth=2
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
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif
