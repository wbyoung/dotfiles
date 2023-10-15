source-local "zsh/pollen.zsh"

[[ -z "$ZSH" ]] && export ZSH="$POLLEN/oh-my-zsh"
[[ -z "$ZSH_CUSTOM" ]] && export ZSH_CUSTOM="$POLLEN"

pollinate tonyseek/oh-my-zsh-virtualenv-prompt#plugins/virtualenv-prompt --no-source

plugins=(git github gulp virtualenv-prompt)
pollinate robbyrussell/oh-my-zsh
pollinate hyperupcall/autoenv
pollinate gmarik/vundle --no-source
