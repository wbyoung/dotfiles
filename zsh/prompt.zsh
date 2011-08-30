source-local "zsh/plugins.zsh"

PROMPT='%{$fg[blue]%}%n%{$reset_color%}:%{$fg[magenta]%}%m%{$reset_color%}:%{$fg_bold[cyan]%}${PWD/#$HOME/~}%{$reset_color%}$(virtualenv_prompt_info)$(git_prompt_info)
$ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_UNTRACKED="?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[yellow]%} @"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}"
