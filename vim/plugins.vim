" Plugins
"
" Reload with:
" vim --noplugin -u $VIM_SETTINGS/plugins.vim -N "+set hidden" "+syntax on" +PlugClean! +PlugInstall +qall

source $POLLEN/vim-plug/plug.vim
call plug#begin()

let is_remote=trim(system('[ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && echo yes')) == "yes"

" Languages
if !is_remote
  Plug 'sheerun/vim-polyglot'
  Plug 'davidhalter/jedi-vim'
  Plug 'garbas/vim-snipmate'
  Plug 'honza/vim-snippets'
  Plug 'jtratner/vim-flavored-markdown'
  Plug 'scrooloose/syntastic'
endif

" Git
Plug 'mattn/gist-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

" Appearance
Plug 'chrisbra/color_highlight'
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

" Textobjects
if !is_remote
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'kana/vim-textobj-function'
  Plug 'kana/vim-textobj-user'
  Plug 'lucapette/vim-textobj-underscore'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'thinca/vim-textobj-function-javascript'
  Plug 'vim-scripts/argtextobj.vim'
  Plug 'bps/vim-textobj-python'
endif

" Search
if !is_remote
  Plug 'rking/ag.vim'
  Plug 'vim-scripts/IndexedSearch'
  Plug 'nelstrom/vim-visual-star-search'
  Plug 'skwp/greplace.vim'
  Plug 'Lokaltog/vim-easymotion'
endif

" Project
if !is_remote
  Plug 'scrooloose/nerdtree'
endif
Plug 'ctrlpvim/ctrlp.vim'

" Vim-improvements
if !is_remote
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'Raimondi/delimitMate'
  Plug 'kristijanhusak/vim-multiple-cursors'
  Plug 'bogado/file-line'
  Plug 'mattn/webapi-vim'
  Plug 'sjl/gundo.vim'
  Plug 'skwp/YankRing.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-scripts/AnsiEsc.vim'
  Plug 'vim-scripts/sudo.vim'
  Plug 'goldfeld/ctrlr.vim'
  Plug 'terryma/vim-expand-region'
  Plug 'scrooloose/nerdcommenter'
endif
Plug 'tpope/vim-tbone'

" Required by rking/ag.vim
if !is_remote
  Plug 'MarcWeber/vim-addon-mw-utils'
endif

call plug#end()
