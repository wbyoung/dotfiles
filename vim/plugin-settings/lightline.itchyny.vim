let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [
      \               'git_branch',
      \               'git_status_staged',
      \               'git_status_workingdir',
      \               'readonly',
      \               'filename',
      \               'modified' ] ]
      \ },
      \ 'component_expand': {
      \   'git_branch': 'MyGitBranchName',
      \   'git_status_staged': 'MyGitStatusStaged',
      \   'git_status_workingdir': 'MyGitStatusWorkingdir',
      \ },
      \ 'component_type': {
      \   'git_status_staged': 'tabsel',
      \   'git_status_workingdir': 'warning',
      \ },
      \ 'component_function': {
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

function! MyGitBranchName() abort
  if exists('*FugitiveHead')
    let branch_name = FugitiveHead()
    if strlen(branch_name)
      return '| ' . branch_name
    endif
  endif
  return ''
endfunction

function! MyGitStatusStaged() abort
  if exists('b:statusline_git_flag_staged')
    return b:statusline_git_flag_staged
  endif
  return ''
endfunction

function! MyGitStatusWorkingdir() abort
  if exists('b:statusline_git_flag_workingdir')
    return b:statusline_git_flag_workingdir
  endif
  return ''
endfunction

" ref: https://github.com/dhruvasagar/dotfiles/blob/54fb768/vim/plugin/statusline.vim#L22
" ref: https://github.com/dhruvasagar/dotfiles/blob/54fb768/vim/autoload/functions.vim#L20
function! s:UpdateStatusLineGitFlags()
  unlet! b:statusline_git_flag_staged
  unlet! b:statusline_git_flag_workingdir

  if !file_readable(expand('%')) || !exists('*FugitiveExtractGitDir')
    let b:statusline_git_flag_staged = ''
    let b:statusline_git_flag_workingdir = ''
  else
    let path = fnamemodify(FugitiveExtractGitDir('.'), ':h')
    let cmd = 'git status --porcelain=v2 ' . expand('%') . " 2>/dev/null | awk '{print $2}'"
    let status = system('cd ' . fnameescape(path) . '; ' . cmd)[:-2]
    let b:statusline_git_flag_staged = status[0] == '.' ? '' : status[0]
    let b:statusline_git_flag_workingdir = status[1] == '.' ? '' : status[1]
  endif

  call lightline#update()
endfunction

augroup status_line
  autocmd!
  autocmd WinEnter,CursorHold * call <SID>UpdateStatusLineGitFlags()
augroup END

" Use status bar even with single buffer
set laststatus=2
