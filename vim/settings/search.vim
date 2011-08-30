" Search
set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...Unless we type a capital

"Use the silver searcher for lightning fast Gsearch command
set grepprg=git\ grep
let g:grep_cmd_opts = '--line-number'
