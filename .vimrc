set nocompatible    " turn off Vi compatibility

""" begin Vundle stuff

filetype off

" include and start Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/nerdtree'

" color schemes
Plugin 'michalbachowski/vim-wombat256mod'

call vundle#end()
filetype plugin indent on

""" end Vundle stuff

" use UTF-8 encoding
set encoding=utf-8

" choose a color scheme
:colorscheme wombat256mod
syntax on

" highlight searches
set hlsearch

" use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" allow backspacing over autoindent, line breaks, start of insert action
set backspace=indent,eol,start

" turn on autoindent
set autoindent

" always display status line, even if only one window is displayed
set laststatus=2
" status line format
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" use visual bell instead of beeping when doing something wrong
set visualbell
" then turn off visual bell
set t_vb=
" t_vb gets reset when the GUI opens...tell it to turn it back off
au GUIEnter * set t_vb=

" command window height = 2
set cmdheight=2

" use 4 spaces instead of tab
set shiftwidth=4
set softtabstop=4
set expandtab

" display line numbers
set number

" flag trailing whitespace in programming language files
:highlight TrailingWhitespace ctermbg=red guibg=red
au BufRead,BufNewFile *.py,*.pyw,*.c,*.cpp,*.h match TrailingWhitespace /\s\+$/

" open a NERDTree window in VIM startup
au vimenter * NERDTree

" allow NERDTree to see hidden files/folders
let NERDTreeShowHidden=1

