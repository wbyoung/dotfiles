scriptencoding utf-8

" Disable squiggly underline and just use straight underline on color terminals
" because for many it seems to result in spell checking not being visible.
if &term == 'xterm-256color' || &term == 'screen-256color'
    set t_Cs=
endif

colorscheme solarized

set background=dark             " Define background style
set number                      " Line numbers are good
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set showmode                    " Show current mode down the bottom
set gcr=a:blinkon0              " Disable cursor blink
set visualbell                  " No sounds
set autoread                    " Reload files changed outside vim
set hidden                      " See http://items.sjbach.com/319/configuring-vim-right
set wmh=0                       " Windows need not have height
set mouse=a                     " Enable mouse
set encoding=utf-8              " UTF-8 makes the world a better place
set clipboard=unnamed           " Share * register w/ unnamed (system copy/paste support)
set noequalalways               " Don't resize when closing splits
syntax on                       " Turn on syntax highlighting

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       " Don't wrap lines
set linebreak    " Wrap lines at convenient points

" Disable the scrollbars (NERDTree)
set guioptions-=r
set guioptions-=L
