scriptencoding utf-8

" Disable squiggly underline and just use straight underline on color terminals
" because for many it seems to result in spell checking not being visible.
if &term =~ '^\(xterm\|screen\)-[0-9]\+color$'
    set t_Cs=
endif

" Particularly on neovim, ensure that the default is not to display GUI colors
" so that the 16 base terminal colors are appropriately used for display.
set notermguicolors

colorscheme solarized

" To simplify setup of vim across local, remote, and tmux based sessions while
" allowing the color palette of the terminal emulator to be updated on the local
" machine, it is easiest to make the dark mode a full invert of the light mode.
" A full invert means that in dark mode, white will render as black and black as
" white. With this type of style, the background should always be set to light
" in vim & it will render based on the underlying emulator palette as dark when
" appropriate. There's a small script to extract the terminal emulator style
" that can handle determining the platform, `terminal-style`.
let term_style=system('terminal-style')
if term_style =~ 'dark' && term_style !~ 'full-invert'
    set background=dark
else
    set background=light
endif

" Limit to 16 ANSI colors to ensure tools don't use colors outside of the
" defined palette.
set t_Co=16

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

if has('nvim')
    hi statusline cterm=NONE gui=NONE
    hi tabline cterm=NONE gui=NONE
    hi winbar cterm=NONE gui=NONE
endif
