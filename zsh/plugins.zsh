source-local "zsh/pollen.zsh"

[[ -z "$ZSH" ]] && export ZSH="$POLLEN/oh-my-zsh"
[[ -z "$ZSH_CUSTOM" ]] && export ZSH_CUSTOM="$POLLEN"

pollinate tonyseek/oh-my-zsh-virtualenv-prompt#plugins/virtualenv-prompt --no-source

plugins=(colorize git github gulp vi-mode virtualenv-prompt)
pollinate robbyrussell/oh-my-zsh
pollinate hyperupcall/autoenv
pollinate junegunn/vim-plug --no-source
