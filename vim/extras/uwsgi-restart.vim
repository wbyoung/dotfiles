function! RestartUWSGI()
  call system('touch config/uwsgi.ini')
endfunction

nnoremap \ :call RestartUWSGI()<CR>
