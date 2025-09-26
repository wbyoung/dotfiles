if (! empty($SSH_CLIENT) || ! empty($SSH_TTY))
  augroup remote_clipboard
    autocmd!
    autocmd TextYankPost * call system('nc localhost 2224', @")
  augroup END
endif
