" Resize windows with +/-
nnoremap <silent> <Leader>= :resize <CR>
nnoremap <silent> <Leader>- :resize -1000<CR>
nnoremap = <C-w>+
nnoremap - <C-w>-
nnoremap _ <C-w><
nnoremap +  <C-w>>

" Quickly move between windows & resize
nnoremap <C-k> :wincmd k<CR>:resize<CR>
nnoremap <C-j> :wincmd j<CR>:resize<CR>

" Text selection
nnoremap gp `[v`]` " reselect pasted text
