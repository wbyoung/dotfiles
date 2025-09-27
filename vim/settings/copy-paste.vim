if (! empty($SSH_CLIENT) || ! empty($SSH_TTY))
  augroup remote_clipboard
    autocmd!
    autocmd TextYankPost * call system('nc localhost 2224', @")
  augroup END
endif


if ($XDG_SESSION_TYPE ==# 'wayland' || ! empty($WAYLAND_DISPLAY)) && !has('nvim')
  augroup wayland_clipboard
    autocmd!
    autocmd FocusLost * call system('wl-copy --trim-newline', @")
  augroup END
endif
