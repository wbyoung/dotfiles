
if (!empty($SSH_CLIENT) || !empty($SSH_TTY))
  nnoremap <silent> <leader>y :call system('nc localhost 2224', @")<CR>
endif


if ($XDG_SESSION_TYPE ==# 'wayland' || !empty($WAYLAND_DISPLAY)) && !has('nvim')
  augroup wayland_clipboard
    autocmd!
    autocmd TextYankPost * silent! call system('wl-copy --trim-newline', @")
  augroup END
endif
