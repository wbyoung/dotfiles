
if (!empty($SSH_CLIENT) || !empty($SSH_TTY))
  augroup remote_clipboard
    autocmd!
    autocmd TextYankPost * silent! call system('remote-copy', @")
  augroup END
endif


if has('nvim')
  set clipboard=unnamedplus
  if executable('gpaste-client')
    let g:clipboard = {
        \ 'name': 'gpaste',
        \ 'copy': {
        \   '+': 'gpaste-client add',
        \   '*': 'gpaste-client add',
        \ },
        \ 'paste': {
        \   '+': 'gpaste-client get --use-index 0',
        \   '*': 'gpaste-client get --use-index 0',
        \ },
        \ 'cache_enabled': 0,
        \ }
  endif
elseif ($XDG_SESSION_TYPE ==# 'wayland' || !empty($WAYLAND_DISPLAY))
  let copy_command = executable('gpaste-client')
    \ ? 'gpaste-client add'
    \ : 'wl-copy --trim-newline'
  augroup wayland_clipboard
    autocmd!
    autocmd TextYankPost * silent! call system(copy_command, @")
  augroup END
endif
