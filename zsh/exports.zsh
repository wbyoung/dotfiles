source-local "zsh/plugins.zsh"

local dotfiles_dir="${${(%):-%x}:A:h:h}"

export PATH="${dotfiles_dir}/bin:${dotfiles_dir}/gists/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export DISABLE_AUTO_TITLE=true
export EDITOR="vim"
export LESS="$LESS -FRX"
export AUTOENV_ENABLE_LEAVE=true
