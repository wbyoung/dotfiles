let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'readonly': 'MyReadonly',
      \ }
      \ }

function! MyReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "⩌"
  else
    return ""
  endif
endfunction

function! MyFugitive()
  if exists("*FugitiveHead")
    let _ = FugitiveHead()
    return strlen(_) ? '| '._ : ''
  endif
  return ''
endfunction

" Use status bar even with single buffer
set laststatus=2
