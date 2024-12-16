" Vundles
"
" Reload with:
" vim --noplugin -u $VIM_SETTINGS/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall

" Filetype off is required by vundle
filetype off

exe 'set rtp+=' . expand('$POLLEN/vundle')
call vundle#rc()

" let Vundle manage Vundle (required)
Bundle "gmarik/vundle"

" Languages
Bundle 'sheerun/vim-polyglot'
Bundle 'davidhalter/jedi-vim'
Bundle 'garbas/vim-snipmate.git'
Bundle 'honza/vim-snippets'
Bundle 'jtratner/vim-flavored-markdown.git'
Bundle 'scrooloose/syntastic.git'
Bundle 'flowtype/vim-flow'

" Git
Bundle "mattn/gist-vim"
Bundle "tpope/vim-fugitive"
Bundle "tpope/vim-git"

" Appearance
Bundle "chrisbra/color_highlight.git"
Bundle "altercation/vim-colors-solarized"
Bundle "itchyny/lightline.vim"

" Textobjects
Bundle "michaeljsmith/vim-indent-object"
Bundle "kana/vim-textobj-function"
Bundle "kana/vim-textobj-user"
Bundle "lucapette/vim-textobj-underscore"
Bundle "nathanaelkane/vim-indent-guides"
Bundle "thinca/vim-textobj-function-javascript"
Bundle "vim-scripts/argtextobj.vim"
Bundle "bps/vim-textobj-python"

" Search
Bundle "rking/ag.vim"
Bundle "vim-scripts/IndexedSearch"
Bundle "nelstrom/vim-visual-star-search"
Bundle "skwp/greplace.vim"
Bundle "Lokaltog/vim-easymotion"

" Project
Bundle "scrooloose/nerdtree.git"
Bundle "ctrlpvim/ctrlp.vim"

" Vim-improvements
Bundle "AndrewRadev/splitjoin.vim"
Bundle "Raimondi/delimitMate"
Bundle "kristijanhusak/vim-multiple-cursors"
Bundle "bogado/file-line.git"
Bundle "mattn/webapi-vim.git"
Bundle "sjl/gundo.vim"
Bundle "skwp/YankRing.vim"
Bundle "tpope/vim-surround.git"
Bundle "tpope/vim-unimpaired"
Bundle "vim-scripts/AnsiEsc.vim.git"
Bundle "vim-scripts/sudo.vim"
Bundle "goldfeld/ctrlr.vim"
Bundle "terryma/vim-expand-region"
Bundle "scrooloose/nerdcommenter"
Bundle "tpope/vim-tbone"

" Required by rking/ag.vim
Bundle "MarcWeber/vim-addon-mw-utils.git"

"Filetype plugin indent on is required by vundle
filetype plugin indent on
