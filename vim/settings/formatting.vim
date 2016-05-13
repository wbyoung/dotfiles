" Auto-wrap comments & recognize lists
set formatoptions+=t,c,r,n

" Spell check
set spell spelllang=en_us
autocmd FileType c,cpp,java,php,python,javascript,json,ruby
    \ setlocal spellcapcheck= " don't check capitalization of source code

" Trim trailing whitespace on write
autocmd FileType c,cpp,java,php,python,javascript,json,ruby,markdown
    \ autocmd BufWritePre * :%s/\s\+$//e
