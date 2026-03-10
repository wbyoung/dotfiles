
if (!empty($SSH_CLIENT) || !empty($SSH_TTY))
  augroup remote_clipboard
    autocmd!
    autocmd TextYankPost * silent! call system('remote-copy', @")
  augroup END
endif


if has('nvim')
  set clipboard=unnamedplus
elseif ($XDG_SESSION_TYPE ==# 'wayland' || !empty($WAYLAND_DISPLAY))
  augroup wayland_clipboard
    autocmd!
    autocmd TextYankPost * silent! call system('wl-copy --trim-newline', @")
  augroup END
endif
