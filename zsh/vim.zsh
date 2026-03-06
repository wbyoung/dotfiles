
export VIM_SETTINGS="$DOTFILES/vim"

if (( $+commands[nvim] )); then
  alias vi=nvim
  alias vim=nvim
fi
