source-local "zsh/plugins.zsh"

path=(${^DOTFILES_DIRS}/bin ~/.local/bin /usr/local/bin /usr/local/sbin $path)

export DISABLE_AUTO_TITLE=true
export LESS="$LESS -FRX"
export AUTOENV_ENV_FILENAME=".autoenv"
export AUTOENV_ENV_LEAVE_FILENAME=".autoenv.leave"
export AUTOENV_ENABLE_LEAVE=true
export KIND_EXPERIMENTAL_PROVIDER="podman"

if [ -x "$(command -v nvim)" ]; then
  export EDITOR="nvim"
  export GIT_EDITOR="nvim"
else
  export EDITOR="vim"
  export GIT_EDITOR="vim"
fi
