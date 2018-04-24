set nocompatible    " turn off Vi compatibility



""" Vundle stuff """

filetype off

" include and start Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" plugins
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/DoxygenToolkit.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'python-mode/python-mode'

" color schemes
Plugin 'michalbachowski/vim-wombat256mod'

call vundle#end()
filetype plugin indent on



""" keymaps """

let mapleader = " "

" need to remap PythonMode 'breakpoint' keymap before we set the CtrlP hotkeys
let g:pymode_breakpoint_bind = '<Leader>k'

" NERDTree
" Toggle the NERDTree file explorer
noremap <Leader>n :NERDTreeToggle <CR>

" CtrlP
" open in file mode
noremap <Leader>f :CtrlP <CR>
" open in buffer mode
noremap <Leader>b :CtrlPBuffer <CR>

" toggle relative or non-relative line numbers
function! LineNumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc
noremap <Leader>l :call LineNumberToggle()<CR>

" replace the current word with what's in register 0
noremap <Leader>rw viw"0p

" turn off highlighted search
noremap <Leader>h :nohl<CR>

" close any open preview window
noremap <Leader>pc :pc<CR>

" close any open help window
noremap <Leader>hc :helpc<CR>

" move the current line up or down
nnoremap <C-S-k> ml:m-2<CR>`l:delm l<CR>
nnoremap <C-S-j> ml:m+<CR>`l:delm l<CR>
inoremap <C-S-k> <ESC>:m .-2<CR>==gi
inoremap <C-S-j> <ESC>:m .+1<CR>==gi

" move the current selection up or down
vnoremap <C-S-k> :m '<-2<CR>gv=gv
vnoremap <C-S-j> :m '>+1<CR>gv=gv

" resize splits
nnoremap <C-up> :resize +2<CR>
nnoremap <C-down> :resize -2<CR>
nnoremap <C-right> :vertical resize +2<CR>
nnoremap <C-left> :vertical resize -2<CR>

" inverse tab
inoremap <S-tab> <C-d>


""" non-basic settings """

" CtrlP settings
let g:ctrlp_arg_map = 1

" NERDTree settings
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden = 1

" PythonMode settings
let g:pymode_folding = 0                " disable automatic code folding
let g:pymode_options_colorcolumn = 0    " disable coloring the 80th column

" flag trailing whitespace in programming language files
autocmd ColorScheme * highlight TrailingWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd BufRead,BufNewFile *.py,*.pyw,*.c,*.cpp,*.h match TrailingWhitespace /\s\+$/



""" basic VIM settings """

" set up the handling of xterm keys when we're in a tmux session
if $TERM =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" use UTF-8 encoding
set encoding=utf-8

" enable the mouse in normal and visual mode
set mouse=nv

" choose a color scheme (set the ones we want in reverse order, and fail
" silently if one doesn't exist)
silent! :colorscheme desert
silent! :colorscheme industry
if $TERM =~ "256color$"
    silent! :colorscheme wombat256mod
endif
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
set statusline=%<%f\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P

" use visual bell instead of beeping when doing something wrong
set visualbell
" then turn off visual bell
set t_vb=

" command window height = 2
set cmdheight=2

" use 4 spaces instead of tab
set shiftwidth=4
set softtabstop=4
set expandtab

" display line numbers
set number

" source site-specific vimrc file
if filereadable("~/.vimrc-site")
    source ~/.vimrc-site
endif

