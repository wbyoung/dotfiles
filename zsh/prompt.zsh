source-local "zsh/plugins.zsh"

RPROMPT=""
PROMPT='%{$fg[blue]%}%n%{$reset_color%}:%{$fg[magenta]%}%m%{$reset_color%}:%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}$(virtualenv_prompt_info)$(git_prompt_info)$(vi_mode_prompt_info)
$ '

VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_NORMAL=6
VI_MODE_CURSOR_VISUAL=0
VI_MODE_CURSOR_INSERT=2
VI_MODE_CURSOR_OPPEND=5
MODE_INDICATOR="$fg_bold[red] <<<%f"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_UNTRACKED="?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[yellow]%} @"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}"
