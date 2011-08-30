" Auto-wrap comments & recognize lists
set formatoptions+=t,c,r,n

" Trim trailing whitespace on write
autocmd FileType c,cpp,java,php,python,javascript,json,ruby,markdown autocmd BufWritePre * :%s/\s\+$//e
