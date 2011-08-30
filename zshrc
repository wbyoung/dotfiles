if [[ -a ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

DOTFILES="${${(%):-%x}:A:h}"
local_loaded=()

source-local() {
  local file
  file="$DOTFILES/$1"
  file="${file:A}"

  if [[ "${local_loaded#*$file}" == "${local_loaded}" ]]; then
    local_loaded+=($file)
    source $file
  fi
}

for file in $DOTFILES/zsh/**/*.zsh; do
  source-local "zsh/${file:t}"
done

unset -f source-local
unset local_loaded
unset DOTFILES
