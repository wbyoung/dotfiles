DOTFILES="${${(%):-%x}:A:h}"
DOTFILES_EXTRAS=()

if [[ -r "$DOTFILES/config.json" ]] && (( $+commands[jq] )); then
  DOTFILES_EXTRAS=(${="$(jq -r '.extras // ""' "$DOTFILES/config.json")"})
fi

DOTFILES_DIRS=("$DOTFILES" "${DOTFILES:h}/.dotfiles-"${^DOTFILES_EXTRAS})
local_loaded=()

-source-once() {
  local file="${1:A}"

  if (( ! ${local_loaded[(Ie)$file]} )); then
    local_loaded+=("$file")
    source "$file"
  fi
}

source-local() { -source-once "$DOTFILES/$1" }
source-dotfiles() { -source-once "${DOTFILES:h}/.dotfiles-$1/$2" }

for dir in $DOTFILES_DIRS; do
  for file in $dir/zsh/**/*.zsh(N); do
    -source-once "$file"
  done
done

unset -f -- -source-once source-local source-dotfiles
unset local_loaded file dir
unset DOTFILES DOTFILES_EXTRAS DOTFILES_DIRS

if [[ -a ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
