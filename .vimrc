" 'ward off unexpected things'
set nocompatible

" enable syntax highlighting
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
" set line number color to grey
:highlight LineNr ctermfg=grey
