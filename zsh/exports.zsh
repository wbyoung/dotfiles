source-local "zsh/plugins.zsh"

local dotfiles_dir="${${(%):-%x}:A:h:h}"

export PATH="${dotfiles_dir}/bin:${dotfiles_dir}/gists/bin:${HOME}/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export DISABLE_AUTO_TITLE=true
export LESS="$LESS -FRX"
export AUTOENV_ENABLE_LEAVE=true

if [ -x "$(command -v nvim)" ]; then
  export EDITOR="nvim"
  export GIT_EDITOR="nvim"
else
  export EDITOR="vim"
  export GIT_EDITOR="vim"
fi
