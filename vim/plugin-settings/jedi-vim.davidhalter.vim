let g:jedi#auto_initialization = 0
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

nnoremap <silent> <leader>v :call jedi#rename()<cr>
nnoremap <silent> <leader>j :call jedi#goto()<cr>
nnoremap <silent> <leader>i :call jedi#show_documentation()<cr>
nnoremap <silent> <leader>c :call jedi#usages()<cr>
