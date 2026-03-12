let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [
      \               'git_branch',
      \               'git_status_staged',
      \               'git_status_workingdir',
      \               'git_status_hunks',
      \               'readonly',
      \               'filename',
      \               'modified' ] ]
      \ },
      \ 'component_expand': {
      \   'git_branch': 'MyGitBranchName',
      \   'git_status_staged': 'MyGitStatusStaged',
      \   'git_status_workingdir': 'MyGitStatusWorkingdir',
      \   'git_status_hunks': 'MyGitStatusHunks',
      \ },
      \ 'component_type': {
      \   'git_status_staged': 'tabsel',
      \   'git_status_workingdir': 'warning',
      \   'git_status_hunks': 'tabsel',
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

function! MyGitStatusHunks() abort
  if exists('b:statusline_git_flag_hunks')
    return b:statusline_git_flag_hunks
  endif
  return ''
endfunction

" ref: https://github.com/dhruvasagar/dotfiles/blob/54fb768/vim/plugin/statusline.vim#L22
" ref: https://github.com/dhruvasagar/dotfiles/blob/54fb768/vim/autoload/functions.vim#L20
function! s:UpdateStatusLineGitFlags()
  unlet! b:statusline_git_flag_staged
  unlet! b:statusline_git_flag_workingdir
  unlet! b:statusline_git_flag_hunks

  if file_readable(expand('%')) && exists('*FugitiveExtractGitDir')
    let path = fnamemodify(FugitiveExtractGitDir('.'), ':h')
    let cmd = 'git status --porcelain=v2 ' . expand('%') . " 2>/dev/null | awk '{print $2}'"
    let status = system('set -o pipefail; cd ' . fnameescape(path) . '; ' . cmd)[:-2]
    if v:shell_error == 0
      let hunks = []
      let [a,m,r] = GitGutterGetHunkSummary()
      if a > 0
        call add(hunks, printf('+%d', a))
      endif
      if m > 0
        call add(hunks, printf('~%d', m))
      endif
      if r > 0
        call add(hunks, printf('-%d', r))
      endif
      let b:statusline_git_flag_staged = status[0] == '.' ? '' : status[0]
      let b:statusline_git_flag_workingdir = status[1] == '.' ? '' : status[1]
      let b:statusline_git_flag_hunks = join(hunks, ' ')
    endif
  endif

  call lightline#update()
endfunction

augroup status_line
  autocmd!
  autocmd WinEnter,CursorHold * call <SID>UpdateStatusLineGitFlags()
augroup END

" Use status bar even with single buffer
set laststatus=2
