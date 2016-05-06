source-local "zsh/plugins.zsh"

local dotfiles_dir="${${(%):-%x}:A:h:h}"

export PATH="${dotfiles_dir}/bin:$HOME/.linuxbrew/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
export DISABLE_AUTO_TITLE=true
export EDITOR="vim"
export LESS="$LESS -FRX"
